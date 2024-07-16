//并行处理
`timescale 1ns/1ps
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
    wire [31:0] res8;
    wire [31:0] res9;
    wire [31:0] res10;
    wire [31:0] res11;
    wire [31:0] res12;
    wire [31:0] res13;
    wire [31:0] res14;
    wire [31:0] res15;
    wire [31:0] res16;
    wire [31:0] res17;
    wire [31:0] res18;
    wire [31:0] res19;
    wire [31:0] res20;
    wire [31:0] res21;
    wire [31:0] res22;
    wire [31:0] res23;
    wire [31:0] res24;
    wire [31:0] res25;
    wire [31:0] res26;
    wire [31:0] res27;
    wire [31:0] res28;
    wire [31:0] res29;
    wire [31:0] res30;
    wire [31:0] res31;

    assign res0 = b[0] ? a << 0 : 0;
    assign res1 = b[1] ? a << 1 : 0;
    assign res2 = b[2] ? a << 2 : 0;
    assign res3 = b[3] ? a << 3 : 0;
    assign res4 = b[4] ? a << 4 : 0;
    assign res5 = b[5] ? a << 5 : 0;
    assign res6 = b[6] ? a << 6 : 0;
    assign res7 = b[7] ? a << 7 : 0;
    assign res8 = b[8] ? a << 8 : 0;
    assign res9 = b[9] ? a << 9 : 0;
    assign res10 = b[10] ? a << 10 : 0;
    assign res11 = b[11] ? a << 11 : 0;
    assign res12 = b[12] ? a << 12 : 0;
    assign res13 = b[13] ? a << 13 : 0;
    assign res14 = b[14] ? a << 14 : 0;
    assign res15 = b[15] ? a << 15 : 0;
    assign res16 = b[16] ? a << 16 : 0;
    assign res17 = b[17] ? a << 17 : 0;
    assign res18 = b[18] ? a << 18 : 0;
    assign res19 = b[19] ? a << 19 : 0;
    assign res20 = b[20] ? a << 20 : 0;
    assign res21 = b[21] ? a << 21 : 0;
    assign res22 = b[22] ? a << 22 : 0;
    assign res23 = b[23] ? a << 23 : 0;
    assign res24 = b[24] ? a << 24 : 0;
    assign res25 = b[25] ? a << 25 : 0;
    assign res26 = b[26] ? a << 26 : 0;
    assign res27 = b[27] ? a << 27 : 0;
    assign res28 = b[28] ? a << 28 : 0;
    assign res29 = b[29] ? a << 29 : 0;
    assign res30 = b[30] ? a << 30 : 0;
    assign res31 = b[31] ? a << 31 : 0;
    

    always @(posedge clk) begin
        if (!rstn) begin
            result <= 64'd0;
        end else begin
            result <= res0 + res1 + res2 + res3 + res4 + res5 + res6 + res7 +
                    res8 + res9 + res10 + res11 + res12 + res13 + res14 + res15 + 
                    res16 + res17 + res18 + res19 + res20 + res21 + res22 + res23 + 
                    res24 + res25 + res26 + res27 + res28 + res29 + res30 + res31;
        end
    end 


endmodule


module tb_bitwise_multiply;
    reg clk;
    reg rstn;
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] result;

    bitwise_multiply uut(
        .clk(clk),
        .rstn(rstn),
        .a(a),
        .b(b),
        .result(result)
    );

    integer i, j;
    integer file;
    integer flag=0; //检查程序是否在正常工作
    integer file_v, file_py;
    integer ret1, ret2;
    integer error_flag;
    reg [63:0] line1, line2;

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_bitwise_multiply);
        file = $fopen("result_v.txt", "w");
        if (file == 0) begin
            $display("Error opening file.");
            $finish; // 结束仿真
        end
        rstn = 0;
        #13 rstn=1;
        for (i=0; i<10000; i=i+1) begin
            for (j=0; j<10000; j=j+1) begin
                a = i;
                b = j;
                #10;
                // $fwrite(file, "%d\n", result);
                $fdisplay(file, "%0d", result);
                // 必须�? %0d或�??%1d，否则Verilog会自动在前面补空格或者补0
                // 如果�? %d�? 则Verilog会在前面补上空格
                flag = flag + 1;
                $display("%d %d", flag, result);
            end

        end

        $fclose(file);
        $display("Result written to file done.");

        // 打开文件
        file_v = $fopen("result_v.txt", "r");
        file_py = $fopen("result.txt", "r");
        if (file_v == 0 || file_py == 0) begin
            $display("Error opening file.");
            $finish;
        end
        error_flag = 0;
        // 逐行比较文件
        while (!$feof(file_v) && !$feof(file_py)) begin
            ret1 = $fgets(line1, file_v);
            ret2 = $fgets(line2, file_py);

            if (line1 !== line2) begin
                $display("Files are different.");
                error_flag = 1;
                $finish;
            end
        end

        if (!$feof(file_v) || !$feof(file_py)) begin
            $display("Bitwise Multiplier is WRONG.");
            error_flag = 1;
        end

        if (error_flag == 0) begin
            $display("Bitwise Multiplier is CORRECT.");
        end

        // 关闭文件
        $fclose(file_v);
        $fclose(file_py);

        $finish; // 结束仿真
    end

    endmodule