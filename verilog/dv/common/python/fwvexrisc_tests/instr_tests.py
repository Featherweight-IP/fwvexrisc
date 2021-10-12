'''
Created on Oct 11, 2021

@author: mballance
'''

import cocotb
import yaml
import pybfms
from fwvexrisc_tests.test_base import TestBase

class InstrTest(TestBase):
    
    def __init__(self):
        super().__init__()

@cocotb.test()
async def entry(dut):
    print("instr_tests.entry")
    t = InstrTest()
    await t.init()
    await t.run()
    