meta:
  id: chall3
  endian: le
seq:
  - id: records
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: type
        type: u4be
        enum: record_type
      - id: size
        type: u4
      - id: body
        type:
          switch-on: type
          cases:
            record_type::nop: unencrypted_record
            record_type::xor: xor_encrypted_record
            record_type::rol: rol_encrypted_record
        size: size
  unencrypted_record:
    seq:
      - id: content_len
        type: u4
      - id: content
        size: content_len
        type: str
        encoding: ascii
  xor_encrypted_record:
    seq:
      - id: xor_key_len
        type: u4
      - id: xor_key
        size: xor_key_len
      - id: content_len
        type: u4
      - id: decrypted_content
        size: content_len
        process: xor(xor_key)
  rol_encrypted_record:
    seq:
      - id: shift_value
        type: u1
      - id: content_len
        type: u4
      - id: decrypted_content
        size: content_len
        process: rol(shift_value)
enums:
  record_type:
    0x4e4f505f: nop
    0x584f525f: xor
    0x524f4c5f: rol