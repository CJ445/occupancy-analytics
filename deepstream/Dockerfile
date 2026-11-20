FROM nvcr.io/nvidia/deepstream:7.0-triton-multiarch

# Install necessary dependencies
# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    vim \
    python3-pip \
    libavcodec-dev \
    libmpeg2-4 \
    libmpg123-0 \
    && rm -rf /var/lib/apt/lists/*

# Compile the test app for necessary plugins .
WORKDIR /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/deepstream-test5
RUN sed -i 's/CUDA_VER?=.*/CUDA_VER?=12.2/' Makefile
RUN make
RUN ldconfig
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/gstreamer-1.0:$LD_LIBRARY_PATH


# Updated for REST api 
WORKDIR /opt/nvidia/deepstream/deepstream-7.0/sources/gst-plugins/gst-nvmultiurisrcbin
COPY gst-plugins/gst-nvmultiurisrcbin/gstdsnvmultiurisrcbin.cpp /opt/nvidia/deepstream/deepstream-7.0/sources/gst-plugins/gst-nvmultiurisrcbin

RUN sed -i 's/CUDA_VER?=.*/CUDA_VER?=12.2/' Makefile
RUN make 
RUN make install

# Clone the DeepStream Occupancy Analytics repository


RUN git clone https://github.com/NVIDIA-AI-IOT/deepstream-occupancy-analytics.git /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics

# Change to the working directory
WORKDIR /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics

# Modify the Makefile to set the CUDA version
RUN sed -i 's/CUDA_VER?=.*/CUDA_VER?=12.2/' Makefile

# Install Kafka Python package
RUN pip3 install kafka-python
RUN pip3 install psycopg2-binary

# Download models by running the model.sh script
RUN cd config && ./model.sh

# Example build or setup command (if needed)
RUN make
RUN rm -rf /root/.cache/gstreamer-1.0/registry.*

#copy the consumer.py 

COPY scripts/consumer.py /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics
#copy configs
COPY configs/dstest_occupancy_analytics.txt /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics/config
COPY configs/nvdsanalytics_config.txt /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics/config
#updated for REST api
COPY configs/deepstream_nvdsanalytics_meta.cpp /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/occupancy_analytics
