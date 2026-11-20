# RTSP Proxy Setup using MediaMTX

Description : This project sets up an RTSP Proxy using MediaMTX to relay multiple RTSP streams over a network. The proxy enables efficient access to multiple IP camera streams while enforcing TCP-based transport for better stability.

Last Updated: **Feb-17-2024**

## Features

- Proxy multiple RTSP streams (up to 4 streams configured)
- Enforces **TCP transport** for reliability
- Supports **authentication for client access**
- Allows on-demand streaming to reduce resource usage

## Prerequisites

- **Docker** installed on the host machine
- ffmpeg package installed for verification of the streams.
- Access to the RTSP source streams
- Firewall rules allowing RTSP traffic

## Setup

### 1. Make a Project Directory

```bash
mkdir mediamtx-rtsp-proxy
cd mediamtx-rtsp-proxy
```

### 2. Pull the Mediamtx Docker Container.

```bash
docker pull bluenviron/mediamtx
```

### 3. Create a Custom Configuration File

Create a `mediamtx.yml` file in the project directory:

```yaml
rtsp: yes
readTimeout: 30s
writeTimeout: 30s

protocols: [tcp]

paths:
  all:
    rtspTransport: tcp

  stream1:
    source: <rtsp_link_1>
    sourceProtocol: tcp
    sourceOnDemand: yes
    readUser: proxyuser
    readPass: proxypass

  stream2:
    source: <rtsp_link_2>
    sourceProtocol: tcp
    sourceOnDemand: yes
    readUser: proxyuser
    readPass: proxypass

  stream3:
    source: <rtsp_link_3>
    sourceProtocol: tcp
    sourceOnDemand: yes
    readUser: proxyuser
    readPass: proxypass

  stream4:
    source: <rtsp_link_4>
    sourceProtocol: tcp
    sourceOnDemand: yes
    readUser: proxyuser
    readPass: proxypass
```

### 4. Create a Custom Docker Compose File

Create a `docker-compose.yml` file in the project directory:

```yaml
version: '3'
services:
  mediamtx:
    image: bluenviron/mediamtx:latest
    container_name: mediamtx
    ports:
      - "8554:8554"
      - "8888:8888"
    restart: always
    volumes:
      - ./mediamtx.yml:/mediamtx.yml
```

### 5. Run MediaMTX Docker Container

```bash
docker compose up -d
```

```bash
Ouput:
---------------------------------------------------------------------------------
[+] Running 2/2
 ✔ Network mediamtx-rtsp-proxy_default  Created                             0.3s 
 ✔ Container mediamtx                   Started                             2.2s 
```

## Usage

### 1. Streaming the Proxy Streams

Once the proxy is running, clients can access the streams via:

```bash
ffplay rtsp://proxyuser:proxypass@<server_ip>:8554/stream1
ffplay rtsp://proxyuser:proxypass@<server_ip>:8554/stream2
ffplay rtsp://proxyuser:proxypass@<server_ip>:8554/stream3
ffplay rtsp://proxyuser:proxypass@<server_ip>:8554/stream4
```

Replace `server_ip` with the IP of the machine running the proxy.

### 2. Managing the Proxy

### Stopping the Proxy

```bash
docker compose down
```

### Checking Logs

```bash
docker logs -f mediamtx
```

## Troubleshooting

- Ensure the source RTSP URLs are correct and accessible.
- Check firewall settings if streams fail to load.
- Use `docker logs mediamtx` for debugging errors.
- Ensure RTSP traffic is allowed on port **8554**.

## 9. References

• [MediaMTX Documentation](https://github.com/bluenviron/mediamtx)
• [RTSP Proxying in MediaMTX](https://github.com/bluenviron/mediamtx#proxying-rtsp-streams)
