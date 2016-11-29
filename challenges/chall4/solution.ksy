meta:
  id: wim
  file-extension: wim
  endian: le
seq:
  - id: header
    type: wim_header
instances:
  xml_data:
    pos: header.xml_data_hdr.base.offset
    size: header.xml_data_hdr.original_size
    type: str
    encoding: utf-16
  lookup_table:
    type: lookup_table
    pos: header.offset_table_hdr.base.offset
    size: header.offset_table_hdr.original_size
  dir_entry4:
    type: dir_entry
    pos: 0x266
types:
  metadata_resource:
    seq:
      - id: security_data
        type: security_block_disk
      - id: directory_data
        type: dir_entry
  security_block_disk:
    seq:
      - id: total_length
        type: u4
      - id: num_entries
        type: u4
  dir_entry:
    seq:
      - id: length
        type: u8
      - id: body
        type: dir_entry_body
        if: length > 0
  dir_entry_body:
    seq:
      - id: attributes
        type: u4
      - id: security_id
        type: u4
      - id: subdir_offset
        type: u8
      - id: unused1
        type: u8
      - id: unused2
        type: u8
      - id: creation_time
        type: u8
      - id: last_access_time
        type: u8
      - id: last_write_time
        type: u8
      - id: hash
        size: 20
      - id: reparse_tag
        type: u4
      - id: reparse_reserved
        type: u4
      - id: hard_link
        type: u4
      - id: streams
        type: u2
      - id: short_name_length
        type: u2
      - id: file_name_length
        type: u2
      - id: file_name
        type: str
        encoding: utf-16le
        size: file_name_length
      - id: alignment
        size: 10
    instances:
      sub_directories:
        type: dir_entry
        io: _root._io
        pos: 238 + subdir_offset
        if: subdir_offset != 0 and attributes == 16
        #repeat: until
        #repeat-until: _.length == 0
        repeat: expr
        repeat-expr: 2
  lookup_table:
    seq:
      - id: items
        type: lookup_table_item
        repeat: eos
  lookup_table_item:
    seq:
      - id: hdr
        type: reshdr_disk
    instances:
      metadata_resource:
        type: metadata_resource
        io: _root._io
        pos: hdr.short.base.offset
        if: hdr.short.base.flags == 16
  guid:
    seq:
      - id: data1
        type: u4
      - id: data2
        type: u2
      - id: data3
        type: u2
      - id: data4
        size: 8
  reshdr_base_disk:
    seq:
      - id: flags
        type: u1
      - id: size_bytes
        size: 7
      - id: offset
        type: u8
    instances:
      is_free:
        value: (flags & 1) != 0
      is_metadata:
        value: (flags & 2) != 0
      is_compressed:
        value: (flags & 4) != 0
      is_spanned:
        value: (flags & 8) != 0
      is_solid:
        value: (flags & 16) != 0
  reshdr_disk_short:
    seq:
      - id: base
        type: reshdr_base_disk
      - id: original_size
        type: u8
  reshdr_disk:
    seq:
      - id: short
        type: reshdr_disk_short
      - id: part_number
        type: u2
      - id: ref_count
        type: u4
      - id: hash
        size: 20
  wim_header:
    seq:
      - id: image_tag
        size: 8
        type: str
        encoding: ascii
      - id: size
        type: u4
      - id: version
        type: u4
      - id: flags
        type: u4
      - id: compression_size
        type: u4
      - id: wim_guid
        type: guid
      - id: part_number
        type: u2
      - id: total_parts
        type: u2
      - id: image_count
        type: u4
      - id: offset_table_hdr
        type: reshdr_disk_short
      - id: xml_data_hdr
        type: reshdr_disk_short
      - id: boot_metadata_hdr
        type: reshdr_disk_short
      - id: boot_index
        type: u4
      - id: integrity_hdr
        type: reshdr_disk_short
      - id: unused
        size: 60