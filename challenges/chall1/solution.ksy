meta:
  id: chall1
  endian: le
seq:
  - id: my_first_byte
    type: u1
  - id: i_like_negative_numbers
    type: s2le
  - id: half_life_3_confirmed
    type: f4
  - id: only_one
    type: u8be
  - id: message
    type: strz
    encoding: utf-8
  - id: trailer
    type: str
    size: 6
    encoding: ascii