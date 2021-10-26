'''
Created on Oct 11, 2021

@author: mballance
'''
import cocotb
import pybfms
from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
from riscv_debug_bfms.riscv_debug_bfm import RiscvDebugBfm

class TestBase(object):
    
    def __init__(self):
        self.u_sram = None
        pass
    
    async def init(self):
        await pybfms.init()
        
        self.u_sram = pybfms.find_bfm(".*u_sram")
        self.u_dbg : RiscvDebugBfm = pybfms.find_bfm(".*", RiscvDebugBfm)
        
        if "sw.image" not in cocotb.plusargs.keys():
            raise Exception("+sw.image not specified")
        
        self.u_dbg.load_elf(cocotb.plusargs["sw.image"])
        self.load_sw(cocotb.plusargs["sw.image"])

    
    def load_sw(self, sw_image):
        with open(sw_image, "rb") as f:
            elffile = ELFFile(f)
            
#            symtab = elffile.get_section_by_name('.symtab')
                 
#            begin_signature = symtab.get_symbol_by_name("begin_signature")[0]["st_value"]
#            end_signature = symtab.get_symbol_by_name("end_signature")[0]["st_value"]
#            write_str = symtab.get_symbol_by_name("FN_WriteStr")[0]["st_value"]
#            write_num = symtab.get_symbol_by_name("FN_WriteNmbr")[0]["st_value"]
                
            # Find the section that contains the data we need
            section = None
            for i in range(elffile.num_sections()):
                shdr = elffile._get_section_header(i)
    #            print("sh_addr=" + hex(shdr['sh_addr']) + " sh_size=" + hex(shdr['sh_size']) + " flags=" + hex(shdr['sh_flags']))
    #            print("  keys=" + str(shdr.keys()))
                if shdr['sh_size'] != 0 and (shdr['sh_flags'] & 0x2):
                    section = elffile.get_section(i)
                    data = section.data()
                    addr = shdr['sh_addr']
                    j = 0
                    while j < len(data):
                        word = (data[j+0] << (8*0))
                        word |= (data[j+1] << (8*1)) if j+1 < len(data) else 0
                        word |= (data[j+2] << (8*2)) if j+2 < len(data) else 0
                        word |= (data[j+3] << (8*3)) if j+3 < len(data) else 0
                        self.u_sram.write_nb(int((addr & 0xFFFFFF)/4), word, 0xF)
                        addr += 4
                        j += 4        
        pass
    
    async def run(self):
        await cocotb.triggers.Timer(1, "ms")
        pass

    