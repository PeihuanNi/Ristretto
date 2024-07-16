## 位级乘法 Bit-Level-Multiplication

**Algorithm: Bit-Level-Multiplication**
___
```
input: a, b  
output: result
```
```python
# python实现
def Bitwise_Multiply(a, b):
    result = 0
    shift = 0
    while b != 0:
        if b & 1: # b的最低位是1，代表b是奇数
            result += a << shift
        shift += 1
        b >>= 1 # b右移一位
    return result
```
___
    原理是，乘法本质就是b个a相加，
    第一次迭代，当b的最低位为1时，就代表这个迭代是要加1个a，之后b右移一位，最低位维0，说明不需要加a
    第二次迭代，当b的最低为为1时，代表这个迭代要加1<<1=2个a，之后b右移一位，最低位维0，说明不需要加a
    第三次迭代，当b的最低为为1时，代表这个迭代要加1<<2=4个a，只有b右移一位，最低位维0，说明不需要加a
    以此类推，直到b=0，说明结束了
```verilog
// verilog实现
// 这个实现的是一个并行的位级乘法器
// 计算耗时一个时钟周期
module bitwise_multiply (
    input clk,
    input rstn,
    input [31:0] a,
    input [31:0] b,
    output reg [63:0] result
);

    wire [31:0] res0;
    wire [31:0] res1;
    wire [31:0] res2;
    wire [31:0] res3;
    wire [31:0] res4;
    wire [31:0] res5;
    wire [31:0] res6;
    wire [31:0] res7;
    // 实际上就是在判断有几个a相加
    assign res0 = b[0] ? a << 0 : 0;
    assign res1 = b[1] ? a << 1 : 0;
    assign res2 = b[2] ? a << 2 : 0;
    assign res3 = b[3] ? a << 3 : 0;
    assign res4 = b[4] ? a << 4 : 0;
    assign res5 = b[5] ? a << 5 : 0;
    assign res6 = b[6] ? a << 6 : 0;
    assign res7 = b[7] ? a << 7 : 0;
    ······
    ······

    always @(posedge clk) begin
        if (!rstn) begin
            result <= 64'd0;
        end else begin
            result <= res0 + res1 + res2 + res3 + res4 + res5 + res6 + res7 + ······;
        end
    end 

endmodule
```
### 实验结果
#### **8 Bits $\times$ 8 Bits**  
这种乘法器可以大大减少资源的耗费，使用vivado2023.1仿真结果如下，并与Xilinx的Multiplier IP（使用LUT）对比，下面所以power指的是整个设计的Total On-Chip Power
___
**Bit-Level-Multiplier**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 69          | 14.091W |
| FF       | 16          | -       |
| IO       | 34          | -       |
| BUFG     | 1           | -       |
___
**Xilinx Multiplier IP Use LUTs**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 60          | 14.754W |
| FF       | 16          | -       |
| IO       | 33          | -       |
| BUFG     | 1           | -       |
___
**Xilinx Multiplier IP Use Mults(DSP)**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 60          | 14.754W |
| FF       | 16          | -       |
| IO       | 33          | -       |
| BUFG     | 1           | -       |
___
使用LUTs和Mults实验结果相同  
可见在bandwidth较低时，两者差距并不明显
#### **32 Bits $\times$ 32 Bits**
**Bit-Level-Multiplier**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 578         | 46.326W |
| FF       | 37          | -       |
| IO       | 130         | -       |
| BUFG     | 1           | -       |
___
**Xilinx Multiplier IP Use LUTs**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 1012        | 85.742W |
| FF       | 64          | -       |
| IO       | 129         | -       |
| BUFG     | 1           | -       |
___
**Xilinx Multiplier IP Use Mults(DSP)**
| Resource | Utilization | Power   |
|:--------:|:-----------:|:-------:|
| LUT      | 1012        | 85.742W |
| FF       | 64          | -       |
| IO       | 129         | -       |
| BUFG     | 1           | -       |
___
在高bindwidth时，差距就很明显了，显然Bit-Level Multiplier在overhead和power都要更优