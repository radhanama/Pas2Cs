namespace Demo {
    public partial class ForDownToDemo {
        public static void Test() {
            for (var i = 3; i >= 1; i--) System.Console.WriteLine(i);
        }
    }
    
    public partial class ForEachExample {
        public static int Sum(int[] arr) {
            int result;
            int total;
            total = 0;
            foreach (var item in arr) total = total + item;
            result = total;
            return result;
        }
    }
    
    public partial class StepExample {
        public static int Sum() {
            int result;
            int i;
            int total;
            total = 0;
            for (i = 1; i <= 5; i += 2) total = total + i;
            result = total;
            return result;
        }
    }
    
    public partial class LoopExample {
        public static void CountThree() {
            int i;
            i = 0;
            while (true) {
                i = i + 1;
                if (i == 3) break;
            }
        }
    }
    
    public partial class RepeatExample {
        public static void LoopIt() {
            int i;
            i = 0;
            do {
                i = i + 1;
            } while (!(i > 3));
        }
    }
    
    public partial class BreakExample {
        public static void DoBreak(int[] arr) {
            int i;
            for (i = 0; i <= arr.Length - 1; i++) {
                if (arr[i] == 0) break;
                if (arr[i] < 0) continue;
            }
        }
    }
    
    public partial class WhileDemo {
        public static void Test(int[] arr) {
            int i = 0;
            while (i <= 2) i = i + arr[0];
        }
    }
    
    public partial class WhileEmptyDemo {
        public static void DoNothing() {
            int i = 0;
            while (i < 3);
        }
    }
    
    public partial class TypedForEach {
        public static int Sum(int[] arr) {
            int result;
            int total;
            total = 0;
            foreach (int item in arr) total = total + item;
            result = total;
            return result;
        }
    }
    
    public partial class ForEachIndexExample {
        public static int Sum(int[] arr) {
            int result;
            int total;
            total = 0;
            for (var idx = 0; idx < arr.Length; idx++) {
                var item = arr[idx];
                total = total + item * idx;
            }
            result = total;
            return result;
        }
    }
    
    public partial class TypedForLoop {
        public static int Sum(int[] arr) {
            int result;
            int total;
            total = 0;
            for (int i = 0; i <= length(arr) - 1; i++) total = total + arr[i];
            result = total;
            return result;
        }
    }
}
