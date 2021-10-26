'''
Created on Oct 26, 2021

@author: mballance
'''
from fwvexrisc_tests.test_base import TestBase
import cocotb

class RiscvComplianceTests(TestBase):
    
    def __init__(self):
        super().__init__()
        self.write_str = -1
        self.write_num = -1
        self.out = ""
        
    def on_exec(self, addr, instr):
#        print("Exec: 0x%08x 0x%08x" % (addr, instr))
        if addr == self.write_str:
#            print("write_str: " + hex(self.a0))
            saddr = self.u_dbg.reg(10)
            for _ in range(64):
                byte = self.u_dbg.mm.read8(saddr)

                if byte != 0:
                    if byte == 0xa:
                        # if self.out.startswith("Test Passed"):
                        #     self.num_passed += 1
                        # if self.out.startswith("Test Failed"):
                        #     self.num_failed += 1
                        print(self.out)
                        self.out = ""
                    else:
                        self.out += "%c" % (byte,)
                else:
                    break
                saddr += 1
        elif addr == self.write_num:
            self.out += hex(self.u_dbg.reg(10))
        
    def memwrite(self, iaddr, waddr, wdata, wmask):
        print("memwrite: 0x%08x waddr=0x%08x wdata=0x%08x wmask=%02x" % (
            iaddr, waddr, wdata, wmask))
        
    async def run(self):
        if "ref.file" not in cocotb.plusargs.keys():
            raise Exception("+ref.file not specified")
        
        ref_file = cocotb.plusargs["ref.file"]
        print("self_loop=0x%08x" % self.u_dbg.sym2addr("self_loop"))
        self.write_str = self.u_dbg.sym2addr("FN_WriteStr")
        self.write_num = self.u_dbg.sym2addr("FN_WriteNmbr")
        self.u_dbg.add_on_exec_cb(self.on_exec)
#        self.u_dbg.add_memwrite_cb(self.memwrite)
        addr = await self.u_dbg.on_exec({"self_loop"})
        
        
        begin_signature = self.u_dbg.sym2addr("begin_signature")
        end_signature = self.u_dbg.sym2addr("end_signature")

        num_passed = 0
        num_failed = 0        
        with open(ref_file, "rb") as ref_fp:
                     
            for cnt,line in enumerate(ref_fp):
                addr = begin_signature + 4*cnt
                exp = int(line, 16)
                actual = self.u_dbg.mm.read32(addr)
                         
                cocotb.log.info("0x%08x: exp=0x%08x actual=0x%08x" % (addr, exp, actual))
                         
                if exp != actual:
                    num_failed += 1
                else:
                    num_passed += 1
                    
        if num_passed > 0 and num_failed == 0:
            print("PASSED")
        else:
            raise Exception("FAILED: num_passed=%d num_failed=%d" % (num_passed, num_failed))
        
@cocotb.test()
async def entry(dut):
    t = RiscvComplianceTests()
    await t.init()
    await t.run()
    
