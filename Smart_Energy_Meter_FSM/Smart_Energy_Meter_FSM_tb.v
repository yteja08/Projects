module smart_energy_meter_fsm_tb;

reg clk;
reg rst;
reg sample_tick;
reg overload;
reg tamper_detected;
reg pay_received;
reg low_credit;

wire measure_enable;
wire relay_on;
wire warning;
wire tamper_alarm;
wire [2:0] state_dbg;
wire [6:0] Seven_Seg;
wire [3:0] digit;

smart_energy_meter_fsm DUT
(
    .clk(clk),
    .rst(rst),
    .sample_tick(sample_tick),
    .overload(overload),
    .tamper_detected(tamper_detected),
    .pay_received(pay_received),
    .low_credit(low_credit),

    .measure_enable(measure_enable),
    .relay_on(relay_on),
    .warning(warning),
    .tamper_alarm(tamper_alarm),
    .state_dbg(state_dbg),
    .Seven_Seg(Seven_Seg),
    .digit(digit)
);

//////////////////////////////////////////////////////////
// Clock Generation
//////////////////////////////////////////////////////////
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////////////////////////
// VCD Dump
//////////////////////////////////////////////////////////
initial
begin
    $dumpfile("waveform_smart_energy_meter_fsm.vcd");
    $dumpvars(0, smart_energy_meter_fsm_tb);
end

//////////////////////////////////////////////////////////
// Stimulus
//////////////////////////////////////////////////////////
initial
begin

    rst             = 1;
    sample_tick     = 0;
    overload        = 0;
    tamper_detected = 0;
    pay_received    = 0;
    low_credit      = 0;

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------
    #20;
    rst = 0;

    //--------------------------------------------------
    // Wait for INIT -> NORMAL
    //--------------------------------------------------
    #40;

    //--------------------------------------------------
    // Sample Tick Check
    //--------------------------------------------------
    sample_tick = 1;
    #10;
    sample_tick = 0;

    #20;

    //--------------------------------------------------
    // LOW CREDIT Scenario
    //--------------------------------------------------
    low_credit = 1;
    #50;

    //--------------------------------------------------
    // Payment Restore
    //--------------------------------------------------
    pay_received = 1;
    #30;
    pay_received = 0;
    low_credit   = 0;

    #30;

    //--------------------------------------------------
    // LOW CREDIT -> DISCONNECTED
    //--------------------------------------------------
    low_credit = 1;

    #80;

    low_credit = 0;

    //--------------------------------------------------
    // Restore from DISCONNECTED
    //--------------------------------------------------
    pay_received = 1;
    #30;
    pay_received = 0;

    #30;

    //--------------------------------------------------
    // OVERLOAD TRIP
    //--------------------------------------------------
    overload = 1;

    #30;

    overload     = 0;
    pay_received = 1;

    #30;

    pay_received = 0;

    #30;

    //--------------------------------------------------
    // TAMPER
    //--------------------------------------------------
    tamper_detected = 1;

    #30;

    tamper_detected = 0;
    pay_received    = 1;

    #30;

    pay_received = 0;

    #40;

    $finish;

end

endmodule
