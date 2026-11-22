import { deflateSync } from 'node:zlib';
import { writeFileSync } from 'node:fs';

const S = 1024;
const px = Buffer.alloc(S * S * 4);
const clamp = (v, a = 0, b = 1) => (v < a ? a : v > b ? b : v);
const mix = (a, b, t) => a + (b - a) * t;

const TEETH = 8;
const R0 = 0.30;
const AMP = 0.055;
const HUB = 0.105;

for (let y = 0; y < S; y++) {
  for (let x = 0; x < S; x++) {
    const u = (x / (S - 1)) * 2 - 1;
    const v = (y / (S - 1)) * 2 - 1;
    const r = Math.sqrt(u * u + v * v);
    const th = Math.atan2(v, u);

    // 灰色渐变底
    const t = clamp((v + 1) / 2);
    let R = mix(0.29, 0.55, t), G = mix(0.29, 0.55, t), B = mix(0.31, 0.56, t);

    // 齿轮
    const gearR = R0 + AMP * Math.cos(TEETH * th);
    const aa = 0.004;
    const inGear = clamp((gearR - r) / aa);
    const inHole = clamp((r - HUB) / aa);
    const white = inGear * inHole;
    if (white > 0) {
      R = mix(R, 0.97, white);
      G = mix(G, 0.97, white);
      B = mix(B, 0.98, white);
    }

    const i = (y * S + x) * 4;
    px[i] = R * 255 | 0;
    px[i + 1] = G * 255 | 0;
    px[i + 2] = B * 255 | 0;
    px[i + 3] = 255;
  }
}

const raw = Buffer.alloc(S * (S * 4 + 1));
for (let y = 0; y < S; y++) {
  raw[y * (S * 4 + 1)] = 0;
  px.copy(raw, y * (S * 4 + 1) + 1, y * S * 4, (y + 1) * S * 4);
}

function crc32(buf) {
  let c, crc = 0xffffffff;
  for (let n = 0; n < buf.length; n++) {
    c = (crc ^ buf[n]) & 0xff;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    crc = (crc >>> 8) ^ c;
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function chunk(type, data) {
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length);
  const t = Buffer.from(type, 'ascii');
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(crc32(Buffer.concat([t, data])));
  return Buffer.concat([len, t, data, crc]);
}

const ihdr = Buffer.alloc(13);
ihdr.writeUInt32BE(S, 0); ihdr.writeUInt32BE(S, 4);
ihdr[8] = 8; ihdr[9] = 6;

const png = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  chunk('IHDR', ihdr),
  chunk('IDAT', deflateSync(raw, { level: 9 })),
  chunk('IEND', Buffer.alloc(0))
]);
writeFileSync(process.argv[2] || 'icon1024.png', png);
console.log('icon:', png.length, 'bytes');
