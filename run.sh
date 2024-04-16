#!/bin/bash

# Run make command to compile C code
make -C examples/sw/simple_system/hello_test 

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful."

    # Execute the compiled program
    ./build/lowrisc_ibex_ibex_simple_system_0/sim-verilator/Vibex_simple_system --meminit=ram,./examples/sw/simple_system/hello_test/hello_test.elf

    # Check if program execution was successful
    if [ $? -eq 0 ]; then
        echo "Program execution successful."

        # Run Python script
        cd examples/sw/simple_system/hello_test

        riscv32-unknown-elf-objdump -d hello_test.elf > hello_test_dump.txt

        if [ $? -eq 0 ]; then
            echo "obj dump successful."

            python3 prof_script.py
            
            if [ $? -eq 0 ]; then
                echo "Function_table: success."

                python3 final_prof.py

                if [ $? -eq 0 ]; then
                     echo "yay! All successfully done"

                else
                    echo "Error in Final_prof"
                fi
            
            else
                echo "Error: function table"
            fi
            
        else
            echo "Error: obj dump"
        fi


    else
        echo "Error: Program execution failed."
    fi
else
    echo "Error: Compilation failed."
fi
