using System.Threading.Tasks;
using System.Threading;

namespace Demo {
    public partial class TaskExample {
        public static void Run() {
            Task.Factory.StartNew(() => {
                Thread.Sleep(3000);
            });
        }
    }
}
