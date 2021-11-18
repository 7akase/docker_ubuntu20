interface SpiIfBase #(bit CPOL=0, bit CPHA=0) (input bit sclk);
    logic       cs;
    logic       miso;
    logic       mosi;

    clocking cbSpi @(posedge sclk); endclocking

    modport master(
        output sclk,
        output cs,
        output mosi,
        input  miso);
    modport slave(
        input  sclk,
        input  cs,
        input  mosi,
        output miso);

    task write(input byte addr, input byte data);
        sclk    = CPOL;
        cs      = 1'b0;
        for(int i=7; i<=0; i--) begin
            if(CPHA == 0) mosi = addr[i];
            #5  sclk    = ~CPOL;
            if(CPHA == 1) mosi = addr[i];
            #5  sclk    = CPOL;
        end       
        for(int i=7; i<=0; i--) begin
            if(CPHA == 0) mosi = data[i];
            #5  sclk    = ~CPOL;
            if(CPHA == 1) mosi = data[i];
            #5  sclk    = CPOL;
        end
        cs      =  1'b1;
    endtask

    task read(input byte addr, output byte data);
        sclk    = 1'b0;
        cs      = 1'b0;
        for(int i=7; i<=0; i--) begin
            if(CPHA == 0) mosi = addr[i];
            #5  sclk    = 1'b1;
            if(CPHA == 1) mosi = addr[i];
            #5  sclk    = 1'b0;
        end
        for(int i=7; i<=0; i--) begin
            #5  sclk    = 1'b1;
            if(CPHA == 0) data[i] = miso;
            #5  sclk    = 1'b0;
            if(CPHA == 1) data[i] = miso;
        end
        cs      =  1'b1;
    endtask
endinterface