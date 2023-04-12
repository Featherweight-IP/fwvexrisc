
package fwvexrisc
import vexriscv.plugin._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._


object FWVexRiscRv32emc extends App {
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new RvfiPlugin,
//        new HaltOnExceptionPlugin,
        new IBusSimplePlugin(
          resetVector = 0x12345678l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE,
          catchAccessFault = false,
          compressedGen = true
        ),
        new DBusSimplePlugin(
          catchAddressMisaligned = false,
          catchAccessFault = false
        ),
        new CsrPlugin(CsrPluginConfig.smallest),
        new DecoderSimplePlugin(
          catchIllegalInstruction = false
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = false,
          rv32e = true
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new MulDivIterativePlugin(
            mulUnrollFactor = 4,
            divUnrollFactor = 1
        ),
        new FullBarrelShifterPlugin,
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = false,
          catchAddressMisaligned = false
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )

//  SpinalConfig().addStandardMemBlackboxing(blackboxAllWhatsYouCan).generateVerilog(cpu())
  SpinalConfig().generateVerilog(cpu())
//  SpinalVerilog(cpu())
}

