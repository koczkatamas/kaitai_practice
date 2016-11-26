# coding=utf-8
import struct

xorKey = '5Up3rs3cR3tK3y'
plainNop = 'unencrypted content'
plainXor = 'xor-encryption is the best encryption'
plainRol = 'just rolling, rolling and rolling'

def xor(str, key):
    return ''.join([chr(ord(str[i]) ^ ord(key[i % len(key)])) for i in xrange(len(str))])

cryptXor = xor(plainXor, xorKey)

def ror(val, r_bits, max_bits):
    return ((val & (2**max_bits-1)) >> r_bits%max_bits) | (val << (max_bits-(r_bits%max_bits)) & (2**max_bits-1))
    
def rorStr(str, val):
    return ''.join([chr(ror(ord(c), val, 8)) for c in str])
    
cryptRol = rorStr(plainRol, 4)
    
def lenStr(str):
    return struct.pack('<I', len(str)) + str
    
def record(type, body):
    return type + '_' + lenStr(body)

open('input.bin', 'wb').write(
    record('ROL', '\x04' + lenStr(cryptRol)) + 
    record('NOP', lenStr(plainNop)) + 
    record('XOR', lenStr(xorKey) + lenStr(cryptXor)))