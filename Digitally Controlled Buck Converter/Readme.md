# Digitally Controlled Voltage Mode Buck Converter

## Introduction

1. Design an digital voltage mode buck converter
   - ADC, DPWM selection
2. Design an digital compensator with Matlab SISOTool
   - Design by Emulation (DBE) Flow
3. Construct Simulink behavior model of digital buck converter with PLECS and Matlab Simulink
4. Evaluate LCO
   - Static situation (A1, A2)
   - Dynamic situation (B1, B2

## System Specification
| Parameter                             | Symbol  | Value               |
|---------------------------------------|---------|---------------------|
| Input Voltage                         | V<sub>g</sub>    | 6V                  |
| Output Voltage                        | V<sub>o</sub>    | 1V                  |
| Switching Frequency                   | f<sub>s</sub>    | 500kHz              |
| Output Current                        | I<sub>o</sub>    | 500mA–1A            |
| Steady-State Output Voltage Ripple    | ΔV<sub>OSS</sub> | < 2%                |
| Steady-State Inductor Current Ripple  | Δi<sub>LSS</sub> | < 0.3A (30% of I<sub>o_max</sub>) |
| Overshoot                             | OS%     | < 10%               |
| Inductance                            | L       | 10μH                |
| Inductor Equivalent Series Resistance | R<sub>L</sub>    | 68mΩ                |
| Capacitance                           | C       | 22μF                |
| Capacitor Equivalent Series Resistance| R<sub>C</sub>    | 20mΩ                |
| Phase Margin                          |                  | >65 degrees         |

ADC: The conversion range of ADC:  

![C](./figure/ADC.png)

DPWM: A necessary condition to avoid the limit cycle oscillation (A1):

![C](./figure/NDPWM.png)

![C](./figure/3.jpg)

## Design process
Consideration of Delay Time
   - The total delay time is Td = Tconv + Tcal + D*Ts + Tg
   - Tconv = 420ns
   - Tcal = propagation delay (10ns)
   - Tg = 55ns + 10ns
   - D*Ts = duty cycle

### Design by Emulation
1. import the transfer function of buck conbveter with delay to SISOTOOL
2. Place the poles and zeros of the compensator on s-domain bode plot
3. Optimize the compensator gain by root locus
4. S-to-Z conversion
5. Co-simulation with ADC and DPWM

## LCO evaluation
 - Static situation
    - A1: DC solution exists to the system
    - A2: Compensator must include an integral action with a limited integral gain
 - Dynamic situation
    - B1: Compensator must result in sufficiently large gain margin of the linear part
    - B2: Gain margin of the close loop system is at least 1.6

