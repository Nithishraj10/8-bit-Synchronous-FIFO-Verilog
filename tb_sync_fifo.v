
`timescale 1ns / 1ps

module tb_sync_fifo;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    integer i;
    integer errors;

    sync_fifo dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // 10 ns clock period
    initial clk = 0;
    always #5 clk = ~clk;

    // Write one data value
    task write_data;
        input [7:0] value;
        begin
            @(negedge clk);
            wr_en = 1;
            rd_en = 0;
            data_in = value;

            @(posedge clk);
            #1;
            @(negedge clk);
            wr_en = 0;
        end
    endtask

    // Read and verify one data value
    task read_check;
        input [7:0] expected;
        begin
            @(negedge clk);
            wr_en = 0;
            rd_en = 1;

            @(posedge clk);
            #1;

            if (data_out !== expected) begin
                $display("FAIL: Expected=%h Got=%h",
                         expected, data_out);
                errors = errors + 1;
            end
            else
                $display("PASS: Read data=%h", data_out);

            @(negedge clk);
            rd_en = 0;
        end
    endtask

    initial begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        errors = 0;

        // TEST 1: Reset
        $display("TEST 1: RESET");
        repeat (2) @(negedge clk);
        rst = 0;
        #1;

        if (empty !== 1 || full !== 0) begin
            $display("FAIL: Reset flags");
            errors = errors + 1;
        end
        else
            $display("PASS: Reset flags");

        // TEST 2: Write and read
        $display("TEST 2: WRITE AND READ");
        write_data(8'hA5);
        write_data(8'h3C);
        write_data(8'hF0);

        read_check(8'hA5);
        read_check(8'h3C);
        read_check(8'hF0);

        // TEST 3: Fill FIFO
        $display("TEST 3: FIFO FULL");
        for (i = 0; i < 16; i = i + 1)
            write_data(i + 8'h10);

        if (full !== 1 || empty !== 0) begin
            $display("FAIL: Full flag");
            errors = errors + 1;
        end
        else
            $display("PASS: Full flag");

        // TEST 4: Overflow attempt
        $display("TEST 4: OVERFLOW");
        write_data(8'hFF);

        if (full !== 1) begin
            $display("FAIL: Overflow protection");
            errors = errors + 1;
        end
        else
            $display("PASS: Overflow blocked");

        // TEST 5: Read all 16 entries
        $display("TEST 5: FIFO DATA ORDER");
        for (i = 0; i < 16; i = i + 1)
            read_check(i + 8'h10);

        if (empty !== 1 || full !== 0) begin
            $display("FAIL: Empty flag");
            errors = errors + 1;
        end
        else
            $display("PASS: Empty flag");

        // TEST 6: Underflow attempt
        $display("TEST 6: UNDERFLOW");
        @(negedge clk);
        rd_en = 1;
        @(posedge clk);
        #1;

        if (empty !== 1) begin
            $display("FAIL: Underflow protection");
            errors = errors + 1;
        end
        else
            $display("PASS: Underflow blocked");

        @(negedge clk);
        rd_en = 0;

        // TEST 7: Simultaneous read/write
        $display("TEST 7: SIMULTANEOUS READ/WRITE");

        write_data(8'h55);

        @(negedge clk);
        wr_en = 1;
        rd_en = 1;
        data_in = 8'hAA;

        @(posedge clk);
        #1;

        if (data_out !== 8'h55 ||
            empty !== 0 || full !== 0) begin
            $display("FAIL: Simultaneous operation");
            errors = errors + 1;
        end
        else
            $display("PASS: Simultaneous operation");

        @(negedge clk);
        wr_en = 0;
        rd_en = 0;

        read_check(8'hAA);

        // Final result
        if (errors == 0)
            $display("ALL FIFO TESTS PASSED");
        else
            $display("FIFO FAILED: %0d errors", errors);

        $finish;
    end

endmodule
