#pragma once
#include "radio.hpp"
#include "uv_k5_display.hpp"

template <const System::TOrgFunctions &Fw, const System::TOrgData &FwData,
          Radio::CBK4819<Fw> &RadioDriver>
class CScreenshot {
public:
  CScreenshot()
      : bEnabled(0){};

  void Handle() {
    if (!(GPIOC->DATA & 0b1)) {
      return;
    }

    if (FreeToDraw()) {
      Fw.WriteSerialData(FwData.pDisplayBuffer, 0xff);
      Fw.WriteSerialData(FwData.pDisplayBuffer + 0xff, 0xff);
      Fw.WriteSerialData(FwData.pDisplayBuffer + 0x1fe, 0xff);
      Fw.WriteSerialData(FwData.pDisplayBuffer + 0x2fd, 0x83);
      bEnabled = false;
      return;
    }
  }

private:
  bool FreeToDraw() {
    bool bFlashlight = (GPIOC->DATA & GPIO_PIN_3);
    if (bFlashlight) {
      bEnabled = true;
      GPIOC->DATA &= ~GPIO_PIN_3;
      *FwData.p8FlashLightStatus = 3;
    }

    return bEnabled;
  }
  bool bEnabled = false;
};