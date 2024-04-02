Consider a parking lot with a single entry and exit gate. Two pairs of photo sensors are used
to monitor the activity of cars. When an object is between the photo transmitter and the photo receiver, the light is blocked and the corresponding output
is asserted to '1'. By monitoring the events of two sensors, we can determine whether a car is entering or exiting or a pedestrian is passing through. 
For example, the following sequence indicates that a car enters the lot:
1.Initially, both sensors are unblocked (i.e., the a and b signals are ''00'').
2. Sensor a is blocked (i.e., the a and b signals are "10").
3. Both sensors are blocked (i.e., the a and b signals are "11").
4. Sensor a is unblocked (i.e., the a and b signals are ''01'').
5. Both sensors becomes unblocked (i.e., the a and b signals are "00" ).

Specifications:
a) Design an FSM with two input signals, a and b, and two output signals, enter and exit. The enter and exit signals assert one clock cycle when a car enters and one
   clock cycle when a car exits the lot, respectively.
b) Design a Counter to increment or decrement when a car enters or exits the parking lot.
c) design using two switch inputs to simulate the behaviour of sensor inputs and display the output using a seven-segment display. 
