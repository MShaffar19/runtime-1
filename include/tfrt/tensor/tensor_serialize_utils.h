/*
 * Copyright 2020 The TensorFlow Runtime Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//===- tensor_serialize_utils.h ---------------------------------*- C++ -*-===//
//
// This file declares serialization and deserialization utils for DenseElement
// attributes.
//
//===----------------------------------------------------------------------===//

#ifndef TFRT_SUPPORT_BEF_SERIALIZE_H_
#define TFRT_SUPPORT_BEF_SERIALIZE_H_

#include <cstddef>
#include <cstdint>

#include "llvm/ADT/ArrayRef.h"
#include "tfrt/support/bef_encoding.h"
#include "tfrt/support/forward_decls.h"
#include "tfrt/tensor/dense_view.h"
#include "tfrt/tensor/tensor_metadata.h"

namespace tfrt {

class DenseHostTensor;
class HostContext;
class DenseAttr;

// DenseHostTensor to DenseAttr.
std::vector<uint8_t> SerializeDenseHostTensorToDenseAttr(
    const DenseHostTensor& dht);

// DenseAttr to DenseHostTensor.
llvm::Expected<DenseHostTensor> DeserializeDenseHostTensorFromDenseAttr(
    DenseAttr attr, HostContext* host);

DType ConvertBEFDataTypeToTensorDType(BEFDataType kind);

TensorMetadata CreateTensorMetadata(const DenseAttr& attr);

DenseView CreateDenseView(const DenseAttr& attr);

}  // namespace tfrt

#endif  // TFRT_SUPPORT_BEF_SERIALIZE_H_
