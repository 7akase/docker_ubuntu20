# title

# Top
```plantuml
umv_test <|-- shift_test_base

class umv_test #lightblue
class shift_test_base {
    env0: shift_env
    ---
    build_phase: void
}
shift_test_base o-right- shift_env

shift_test_base <|-- shift_test1
shift_test_base <|-- shift_test2

shift_test1 --> shift_test_seq1: uvm_config_db::set()
shift_test2 --> shift_test_seq2: uvm_config_db::set()
```

# Environment

```plantuml
class uvm_env #lightblue

uvm_env <|-- shift_env

class shift_env{
    agent0: shift_agent
    ---
    build_phase: void
}

shift_env o-- shift_agent

```

# Agent

```plantuml
class uvm_agent #lightblue {
    uvm_active_passive_enum is_active
}

class shift_agent {
    driver
    sequener
    collector
    monitor
    ---
    build_phase()
    connect_phase()
}
shift_agent -up-|> uvm_agent
shift_agent o-- shift_driver
shift_agent o-- shift_sequencer
shift_agent o-- shift_collector
shift_agent o-- shift_monitor

shift_sequencer -right-> shift_driver
shift_driver -right-> shift
shift -right-> shift_collector
shift_collector -right-> shift_monitor: write()

```

# Sequence
Define a set of test scenario set as a subclass of *uvm_sequence*.

```plantuml
uvm_sequence <|-- shift_sequence_base

class uvm_sequence #lightblue

class shift_sequence_base {
    rand int num_data;
    uvm_phase ph;
    new()
    pre_body()  // raise_objection
    post_body()  // drop_objection
}shift_sequence_base

class shift_test_seq1 {
    ---
    new()
    body()
}
shift_sequence_base <|-- shift_test_seq1
shift_sequence_base <|-- shift_test_seq2
```

# Sequencer

```plantuml

class uvm_sequencer_param_base #lightblue {
    REQ:  type
    RSP:  type
    m_last_req_buffer[$]: REQ
    m_last_rsp_buffer[$]: RSP
    # m_num_last_reqs: int
    # num_last_items: int
    # m_num_last_rsps: int
    # m_num_reqs_sent: int
    # sqr_rsp_analysis_fifo: uvm_sequencer_analysis_fifo
    ---

}

uvm_sequencer_param_base <|-- uvm_sequencer

class uvm_sequencer #lightblue {
    REQ: type
    RSP: type
    sequence_item_requested: bit
    get_next_item_called: bit
    ---
    {abstract} stop_sequences(): void
    {abstract} get_next_item(output REQ t)
    {abstract} try_next_item(output REQ t)
    {abstract} item_done(RSP item): void
    {abstract} put(RSP t)
    {abstract} get(RSP t)
    {abstract} peek(RSP t)
    {abstract} item_done_trigger(RSP item): void
    {abstract} item_done_get_grigger_data(): RSP
}

uvm_sequencer <|-- shift_sequencer

```

# Collector

```plantuml
class uvclib_collector_base {
    COL_VIF vif;
    uvm_analysis_port analysis_port
    ---
    {abstract} get_type_name(): string
    connect_phase(uvm_phase)
    run_phase()
    {abstract} get_response()
}
uvclib_collector_base -up-|> uvm_component

class shift_collector{
    ---
    get_response() // copy from vif to ap
}
shift_collector -up-|> uvclib_collector_base
```

# Monitor
```plantuml
uvm_monitor <|-- uvclib_monitor_base
uvclib_monitor_base <|-- shift_monitor

class uvm_monitor #lightblue



```


```plantuml
uvm_sequence_item <|-- shift_item
class uvm_sequence_item #lightblue {
    rst: rand logic
    data_in: rand logic
    q: logic
    data_in_value: logic
    ---
    new()
}
```


```plantuml
class uvm_sequence #lightblue {
    ---
    start()
    {abstract} pre_start()
    {abstract} pre_body()
    ...
}

class uvclib_monitor_base {
    type TR=uvm_sequence_item
    uvm_analysis_imp #(TR,uclib_monitor_base) analysis_export;
    uvm_analysis_port #(TR) item_collected_port;
    ---
    {abstract} write(): void
}

class shift_monitor {
    string data_in
    string response
    ---
    write(TR data): void
    extract_phase(uvm_phase phase): void
}


```



```plantuml

uvm_void <|-- uvm_component

abstract uvm_component #lightblue {
    ---
    {abstract} new();
    {abstract} get_parent(): uvm_component
    ...
    {abstract} build_phase(uvm_phase phase): void
    {abstract} connect_phase(uvm_phase phase): void
    {abstract} end_of_elaboration_phase(uvm_phase phase): void
    {abstract} start_of_simulation_phase(uvm_phase phase): void
    {abstract} run_phase(uvm_phase phase): void
    {abstract} pre_run_phase(uvm_phase phase): void
    {abstract} reset_phase(uvm_phase phase): void
    {abstract} post_reset_phase(uvm_phase phase): void
    ...
}

class uvm_monitor #lightblue

uvm_component <|-- uvm_monitor


uvm_void <|-- uvm_object
uvm_object <|-- uvm_transaction
uvm_transaction <|-- uvm_sequence_item

abstract uvm_void #lightblue
class uvm_object #lightblue
class uvm_transaction #lightblue
class uvm_sequence_item #lightblue


```