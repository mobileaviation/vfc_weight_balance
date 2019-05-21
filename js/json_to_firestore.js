const firebase = require("firebase");
// Required for side-effects
require("firebase/firestore");

// Initialize Cloud Firestore through Firebase
var firebaseConfig = {
    apiKey: "AIzaSyCO21-EkTmNTu8z-euYBxSNmYI54BqyCME",
    authDomain: "weightandbalance-a0909.firebaseapp.com",
    databaseURL: "https://weightandbalance-a0909.firebaseio.com",
    projectId: "weightandbalance-a0909",
    storageBucket: "weightandbalance-a0909.appspot.com",
    messagingSenderId: "172428131882",
    appId: "1:172428131882:web:aa2e09f352194df2"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  
var db = firebase.firestore();

var menu = [  
    {
        "call_sign": "PH-DRT",
        "type": "P28A",
        "bew": 1617.0,
        "beArm": 88.87,
        "beMoment": 143701.3,
        "frontArm": 80.50,
        "rearArm": 118.10,
        "bagageArm": 142.80,
        "feulArm": 95.00,
        "maxFuel": 48.0,
        "mrw": 2558.0,
        "mtow": 2550.0,
        "fwd": 82.0,
        "aft": 93.0,
        "fwdW": 2050.0,
        "mtowFwd": 88.6,
        "maxUtilW": 2130.0
    },
    {
        "call_sign": "PH-UGS",
        "type": "P28A",
        "bew": 1485.7,
        "beArm": 85.28,
        "beMoment": 126713.8,
        "frontArm": 80.50,
        "rearArm": 118.10,
        "bagageArm": 142.80,
        "feulArm": 95.00,
        "maxFuel": 48.0,
        "mrw": 2332.0,
        "mtow": 2325.0,
        "fwd": 83.0,
        "aft": 93.0,
        "fwdW": 1950.0,
        "mtowFwd": 87.0,
        "maxUtilW": 2020.0
    },
    {
        "call_sign": "G-BJSV",
        "type": "P28A",
        "bew": 1533.0,
        "beArm": 91.06,
        "beMoment": 139602.3,
        "frontArm": 80.50,
        "rearArm": 118.10,
        "bagageArm": 142.80,
        "feulArm": 95.00,
        "maxFuel": 48.0,
        "mrw": 2447.0,
        "mtow": 2440.0,
        "fwd": 83.0,
        "aft": 93.0,
        "fwdW": 1950.0,
        "mtowFwd": 88.3,
        "maxUtilW": 2020.0
    },
    {
        "call_sign": "PH-SCT",
        "type": "P28A",
        "bew": 1530.0,
        "beArm": 90.67,
        "beMoment": 138722.0,
        "frontArm": 80.50,
        "rearArm": 118.10,
        "bagageArm": 142.80,
        "feulArm": 95.00,
        "maxFuel": 48.0,
        "mrw": 2447.0,
        "mtow": 2440.0,
        "fwd": 83.0,
        "aft": 93.0,
        "fwdW": 1950.0,
        "mtowFwd": 88.3,
        "maxUtilW": 2020.0
    },
    {
        "call_sign": "G-OBFS",
        "type": "P28A",
        "bew": 1552.0,
        "beArm": 85.82,
        "beMoment": 133186.7,
        "frontArm": 80.50,
        "rearArm": 118.10,
        "bagageArm": 142.80,
        "feulArm": 95.00,
        "maxFuel": 48.0,
        "mrw": 2447.0,
        "mtow": 2440.0,
        "fwd": 83.0,
        "aft": 93.0,
        "fwdW": 1950.0,
        "mtowFwd": 88.3,
        "maxUtilW": 2020.0
    }
 ]

console.log("Start inserting airplanes");
menu.forEach(function(obj) {
    db.collection("VCFAirplanes").add({
        call_sign : obj.call_sign,
        type : obj.type,
        bew : obj.bew,
        beArm : obj.beArm,
        beMoment : obj.beMoment,
        frontArm : obj.frontArm,
        rearArm : obj.rearArm,
        bagageArm : obj.bagageArm,
        feulArm : obj.feulArm,
        maxFuel : obj.maxFuel,
        mrw : obj.mrw,
        mtow : obj.mtow,
        fwd : obj.fwd,
        aft : obj.aft,
        fwdW : obj.fwdW,
        mtowFwd : obj.mtowFwd,
        maxUtilW : obj.maxUtilW
    }).then(function(docRef) {
        console.log("Document written with ID: ", docRef.id);
    })
    .catch(function(error) {
        console.error("Error adding document: ", error);
    });
});