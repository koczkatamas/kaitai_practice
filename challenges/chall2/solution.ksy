meta:
  id: chall2
  endian: be
seq:
  - id: magic
    contents: "CRYPTROLO"
  - id: files
    type: file
    repeat: eos
types:
  file:
    seq:
      - id: filename_len
        type: u4
      - id: filename
        size: filename_len
        type: str
        encoding: ascii
      - id: md5_hash_hex
        size: 32
      - id: content_len
        type: u4
      - id: content
        size: content_len