
# Installation Guide for Customizing `gstdsnvmultiurisrcbin` Plugin

## Overview
This guide details the process of customizing the `gstdsnvmultiurisrcbin` plugin in NVIDIA DeepStream SDK to enhance the `/api/v1/stream/get-stream-info` endpoint. The customization aims to include additional fields, such as the internal `stream_id` integer, in the response, improving traceability of streams in multi-source pipelines.

---

## Problem Statement
The `/api/v1/stream/get-stream-info` endpoint currently provides only basic camera information (`camera_name` and `camera_id`). This limits traceability because operations in the DeepStream pipeline use the internal `source_id`, not the `camera_id`. 

### Proposed Solution
Enhance the response to include the internal `stream_id`, allowing proper mapping between `camera_id` and `stream_id`.

---

## File Structure
The codebase is located at:
```

/opt/nvidia/deepstream/deepstream-7.0/sources/gst-plugins/gst-nvmultiurisrcbin/

```
It contains the following files:
```

.
|-- Makefile
|-- README
|-- gstdsnvmultiurisrcbin.cpp
|-- gstdsnvmultiurisrcbin.h
|-- gstdsnvmultiurisrcbininit.cpp
`-- gstdsnvurisrcbin.h

```

The customization involves editing the `gstdsnvmultiurisrcbin.cpp` file. The updated file is added to the DeepStream configuration folder i.e `deepstream/gst-plugins/gst-nvmultiurisrcbin/`.

---

## Steps to Compile and Install

### Prerequisites
Ensure that you have NVIDIA DeepStream SDK 7.0 installed along with its dependencies:
- CUDA Toolkit
- NVIDIA GPU Driver (version 535 or later)
- GStreamer framework

### Compilation Instructions
1. **Set CUDA Version**: Export or set the appropriate CUDA version in the Makefile.
```

export CUDA_VER=<your_cuda_version>

```
2. **Build Plugin**: Run the following commands to compile and install:
```

make
sudo make install

```

---

## Deployment and Usage

# Updating `gstdsnvmultiurisrcbin.cpp`

The `gstdsnvmultiurisrcbin.cpp` file is crucial for implementing the REST API feature in the DeepStream application. Below are the steps and details you need to follow for updating this file:

## 1. Adding `source_id`

- **Location**: To add the `source_id`, navigate to **line 2302** of the `gstdsnvmultiurisrcbin.cpp` file in deepstream/configs folder.

### Example Code Snippet
You may need to modify or add code around line 2302 to integrate the `source_id`. Here’s a  example of how it might look:

```

// Example modification at line 2302
source_info.source_id = generate_unique_source_id();

```

## 2. Understanding `source_info`

- The `source_info` structure contains various fields that hold metadata about each data source.
- **Field of Interest**: The `source_id` field is critical for tracking and managing individual sources within the application.

### Reference Comment
For additional context and details regarding the implementation of the `source_id`, refer to the following comment on GitHub:

- See the project issue tracker for implementation details on `source_id`.



### Testing Changes
Run your DeepStream application and verify that `/api/v1/stream/get-stream-info` now includes the internal `stream_id` field in its response.

---


This enables better mapping between external identifiers (`camera_id`) and internal identifiers (`stream_id`) used within DeepStream pipelines.

---

## Notes on Dynamic Source Management

The customized plugin supports dynamic addition and deletion of sources, leveraging `nvmultiurisrcbin`. This feature simplifies source control in multi-stream applications compared to manual methods.

