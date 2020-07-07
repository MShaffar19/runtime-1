// Copyright 2020 The TensorFlow Runtime Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// RUN: tfrt_translate -mlir-to-bef %s | bef_executor -devices=cpu | FileCheck %s --dump-input=fail

// CHECK: --- Running 'addV2_dense_dense_f32'
func @addV2_dense_dense_f32() -> !hex.chain{
  %ch_epoch = hex.new.chain
  %cpu = corert.get_device "cpu"

  %operand_0 = corert.executeop(%cpu) "tfrt_test.create_dense_tensor"()
    { shape = [2, 3], values = [-1.0 : f32, -0.5 : f32, 0.0 : f32, 0.5 : f32, 1.0 : f32, 1.5 : f32] } : 1
  %operand_1 = corert.executeop(%cpu) "tfrt_test.create_dense_tensor"()
    { shape = [2, 3], values = [0.0 : f32, 1.0 : f32, 2.0 : f32, 3.0 : f32, 4.0 : f32, 5.0 : f32] } : 1
  %cpu_handle_result = corert.executeop(%cpu) "tf.AddV2"(%operand_0, %operand_1) : 1
  // CHECK: DenseHostTensor dtype = F32, shape = [2, 3], values = [-1.000000e+00, 5.000000e-01, 2.000000e+00, 3.500000e+00, 5.000000e+00, 6.500000e+00]
  %ch_print_cpu = corert.executeop.seq(%cpu, %ch_epoch) "tfrt_test.print"(%cpu_handle_result) : 0

  hex.return %ch_print_cpu : !hex.chain
}

// CHECK: --- Running 'addV2_dense_scalar_f32'
func @addV2_dense_scalar_f32() -> !hex.chain{
  %ch_epoch = hex.new.chain
  %cpu = corert.get_device "cpu"

  %operand_0 = corert.executeop(%cpu) "tfrt_test.create_dense_tensor"()
    { shape = [2, 3], values = [-1.0 : f32, -0.5 : f32, 0.0 : f32, 0.5 : f32, 1.0 : f32, 1.5 : f32] } : 1
  %operand_1 = corert.executeop(%cpu) "tfrt_test.create_from_scalar"()
    { shape = [2, 3], value = 1.0: f32 } : 1
  %cpu_handle_result = corert.executeop(%cpu) "tf.AddV2"(%operand_0, %operand_1) : 1
  // CHECK: DenseHostTensor dtype = F32, shape = [2, 3], values = [0.000000e+00, 5.000000e-01, 1.000000e+00, 1.500000e+00, 2.000000e+00, 2.500000e+00]
  %ch_print_cpu = corert.executeop.seq(%cpu, %ch_epoch) "tfrt_test.print"(%cpu_handle_result) : 0

  hex.return %ch_print_cpu : !hex.chain
}

// CHECK: --- Running 'addV2_scalar_dense_f32'
func @addV2_scalar_dense_f32() -> !hex.chain{
  %ch_epoch = hex.new.chain
  %cpu = corert.get_device "cpu"

  %operand_0 = corert.executeop(%cpu) "tfrt_test.create_from_scalar"()
    { shape = [2, 3], value = 1.0: f32 } : 1
  %operand_1 = corert.executeop(%cpu) "tfrt_test.create_dense_tensor"()
    { shape = [2, 3], values = [0.0 : f32, 1.0 : f32, 2.0 : f32, 3.0 : f32, 4.0 : f32, 5.0 : f32] } : 1
  %cpu_handle_result = corert.executeop(%cpu) "tf.AddV2"(%operand_0, %operand_1) : 1
  // CHECK: DenseHostTensor dtype = F32, shape = [2, 3], values = [1.000000e+00, 2.000000e+00, 3.000000e+00, 4.000000e+00, 5.000000e+00, 6.000000e+00]
  %ch_print_cpu = corert.executeop.seq(%cpu, %ch_epoch) "tfrt_test.print"(%cpu_handle_result) : 0

  hex.return %ch_print_cpu : !hex.chain
}

// CHECK: --- Running 'addV2_scalar_scalar_f32'
func @addV2_scalar_scalar_f32() -> !hex.chain{
  %ch_epoch = hex.new.chain
  %cpu = corert.get_device "cpu"

  %operand_0 = corert.executeop(%cpu) "tfrt_test.create_from_scalar"()
    { shape = [2, 3], value = 1.0: f32 } : 1
  %operand_1 = corert.executeop(%cpu) "tfrt_test.create_from_scalar"()
    { shape = [2, 3], value = 2.0: f32 } : 1
  %cpu_handle_result = corert.executeop(%cpu) "tf.AddV2"(%operand_0, %operand_1) : 1
  // CHECK: ScalarHostTensor dtype = F32, shape = [2, 3], value = 3.000000e+00
  %ch_print_cpu = corert.executeop.seq(%cpu, %ch_epoch) "tfrt_test.print"(%cpu_handle_result) : 0

  hex.return %ch_print_cpu : !hex.chain
}