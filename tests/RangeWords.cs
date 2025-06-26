using System;

namespace Demo {
    public partial class RangeWords {
        public static string ConversaoRecursiva(uint N) {
            switch (N)
            {
                case >= 1 and <= 19: return Unidades[N]; break;
                case 20 or 30 or 40 or 50 or 60 or 70 or 80 or 90: return Dezenas[N / 10] + " "; break;
                case >= 21 and <= 29 or >= 31 and <= 39 or >= 41 and <= 49 or >= 51 and <= 59 or >= 61 and <= 69 or >= 71 and <= 79 or >= 81 and <= 89 or >= 91 and <= 99: return Dezenas[N / 10] + " e " + ConversaoRecursiva(N % 10); break;
                case 100 or 200 or 300 or 400 or 500 or 600 or 700 or 800 or 900: return Centenas[N / 100] + " "; break;
                case >= 101 and <= 199: return " cento e " + ConversaoRecursiva(N % 100); break;
                case >= 201 and <= 299 or >= 301 and <= 399 or >= 401 and <= 499 or >= 501 and <= 599 or >= 601 and <= 699 or >= 701 and <= 799 or >= 801 and <= 899 or >= 901 and <= 999: return Centenas[N / 100] + " e " + ConversaoRecursiva(N % 100); break;
                case >= 1000 and <= 999999: return ConversaoRecursiva(N / 1000) + " mil " + ConversaoRecursiva(N % 1000); break;
                case >= 1000000 and <= 1999999: return ConversaoRecursiva(N / 1000000) + " milhão " + ConversaoRecursiva(N % 1000000); break;
                case >= 2000000 and <= 999999999: return ConversaoRecursiva(N / 1000000) + " milhoes " + ConversaoRecursiva(N % 1000000); break;
                case >= 1000000000 and <= 1999999999: return ConversaoRecursiva(N / 1000000000) + " bilhão " + ConversaoRecursiva(N % 1000000000); break;
                case >= 2000000000 and <= 4294967295: return ConversaoRecursiva(N / 1000000000) + " bilhoes " + ConversaoRecursiva(N % 1000000000); break;
            }
        }
    }
}
