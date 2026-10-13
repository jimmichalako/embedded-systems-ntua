#include <linux/kernel.h>

asmlinkage long my_sys_call(void){

    int team = 3;

    printk(KERN_ALERT "Greetings from kernel and team no. %d\n", team);

    return 0;

}
