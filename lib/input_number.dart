import 'package:flutter/material.dart';

import 'otp_screen.dart';


class InputNumber extends StatelessWidget {
   InputNumber({super.key});
  final TextEditingController _controllerNumber=TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text("Enter Your Mobile Number",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                TextField(
                   autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: _controllerNumber,
                  decoration: InputDecoration(
                    
                    hintText: "ENTER NUMBER ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.orange
                      )
                    )
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(),));

                }, child: Text("Submit"))
                
            ],
            
          ),
        ) ,
      ),
    );
  }
}

