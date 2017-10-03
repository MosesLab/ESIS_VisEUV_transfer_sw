import math

def steinhart(V):
    Rb = 4990
    C1 = 1.285e-3
    C2 = 2.362e-4
    C3 = 9.285e-8
    Vin = 12.

    if V <= 0:
        V = 1e-6

    # R = -Rb * V / (V-Vin)
    R = Rb * (Vin/V - 1)
    return 1 / (C1 + C2 * math.log(R) + C3 * math.pow(math.log(R), 3)) - 273.15