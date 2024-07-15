//并行处理
`timescale 1ns/1ps
module bitwise_multiply (
    input clk,
    input rstn,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);

    wire [15:0] res0;
    wire [15:0] res1;
    wire [15:0] res2;
    wire [15:0] res3;
    wire [15:0] res4;
    wire [15:0] res5;
    wire [15:0] res6;
    wire [15:0] res7;

    assign res0 = b[0] ? a << 0 : 0;
    assign res1 = b[1] ? a << 1 : 0;
    assign res2 = b[2] ? a << 2 : 0;
    assign res3 = b[3] ? a << 3 : 0;
    assign res4 = b[4] ? a << 4 : 0;
    assign res5 = b[5] ? a << 5 : 0;
    assign res6 = b[6] ? a << 6 : 0;
    assign res7 = b[7] ? a << 7 : 0;

    always @(posedge clk) begin
        if (!rstn) begin
            result <= 16'd0;
        end else begin
            result <= res0 + res1 + res2 + res3 + res4 + res5 + res6 + res7;
        end
    end 


endmodule


module tb_bitwise_multiply;
    reg clk;
    reg rstn;
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] result;

    bitwise_multiply uut(
        .clk(clk),
        .rstn(rstn),
        .a(a),
        .b(b),
        .result(result)
    );

    integer i, j;
    integer file;
    integer file_v, file_py;
    integer ret1, ret2;
    integer error_flag;
    reg [15:0] line1, line2;

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
        for (i=0; i<256; i=i+1) begin
            for (j=0; j<256; j=j+1) begin
                a = i;
                b = j;
                #10;
                // $fwrite(file, "%d\n", result);
                $fdisplay(file, "%1d", result);
                // 必须是 %0d或者%1d，否则Verilog会自动在前面补空格或者补0
                // 如果是 %d， 则Verilog会在前面补上空格
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