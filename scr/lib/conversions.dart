
double KgToLbs(double kg) { return 2.20462262 * kg; }

double GalToLiter(double gal) { return 3.78541178 * gal; }

double LiterToKgAvGas(double liter) { return 0.719 * liter; }

double GalToKgAvGas(double gal) { return LiterToKgAvGas(GalToLiter(gal)); }

double GalToLbsAvGas(double gal) { return KgToLbs(GalToKgAvGas(gal)); }