/**
 *
 * Copyright 2019 Twin. All rights reserved.
 *
 */

var TwinHelper = {};

TwinHelper.infiniteLoopTrap = 500;

TwinHelper.evaluationStopped = false;

TwinHelper.reset = function() {
  TwinHelper.infiniteLoopTrap = 500;
  TwinHelper.evaluationStopped = false;
}

TwinHelper.getEvaluationStopStatus = function() {
  return TwinHelper.evaluationStopped ? true : false;
}

TwinHelper.setEvaluationStopStatus = function(status) {
  TwinHelper.evaluationStopped = status ? true : false;
}

TwinHelper.stopEvaluation = function() {
  TwinHelper.reset();
  throw "Code evaluation stopped by client.";
}

TwinHelper.stopInfiniteLoop = function() {
  TwinHelper.reset();
  throw "Infinite loop.";
}

TwinHelper.sendMessage = function(message) {
  
  if(TwinHelper.getEvaluationStopStatus()) {
    TwinHelper.stopEvaluation();
  }
  
  Twin.sendMessage(message);
}

TwinHelper.getMessage = function(message, isAnalog) {
  
  if(TwinHelper.getEvaluationStopStatus()) {
    TwinHelper.stopEvaluation();
  }
  
  return Twin.getMessage(message, isAnalog);
}

TwinHelper.sleep = function(duration) {
  
  if(TwinHelper.getEvaluationStopStatus()) {
    TwinHelper.stopEvaluation();
  }
  
  return Twin.sleep(duration);
}

TwinHelper.getDeviceOrientation = function(orientation) {
  
  if(TwinHelper.getEvaluationStopStatus()) {
    TwinHelper.stopEvaluation();
  }
  
  return Twin.getDeviceOrientation(orientation);
}

TwinHelper.getDeviceShakeStatus = function() {
  
  if(TwinHelper.getEvaluationStopStatus()) {
    TwinHelper.stopEvaluation();
  }
  
  return Twin.getDeviceShakeStatus();
}


