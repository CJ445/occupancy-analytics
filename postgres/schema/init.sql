CREATE TABLE public.location (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing unique identifier
    name VARCHAR(255) NOT NULL,                          -- Name of the location
    description TEXT,                                    -- Additional details or description of the location
    address TEXT                                         -- Physical address of the location
);

COMMENT ON TABLE public.location IS 'Represents high-level locations such as buildings or compounds.';
COMMENT ON COLUMN public.location.id IS 'Unique identifier for the location.';
COMMENT ON COLUMN public.location.name IS 'Name of the location.';
COMMENT ON COLUMN public.location.description IS 'Additional details or description of the location.';
COMMENT ON COLUMN public.location.address IS 'Physical address of the location.';


CREATE TABLE public.area (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing unique identifier
    location_id INTEGER NOT NULL,                        -- Foreign key linking to the parent location
    name VARCHAR(255) NOT NULL,                          -- Name of the area
    description TEXT,                                    -- Additional details or description of the area
    CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES public.location (id) ON DELETE RESTRICT
);

COMMENT ON TABLE public.area IS 'Represents specific areas within a location, such as gates or entrances.';
COMMENT ON COLUMN public.area.id IS 'Unique identifier for the area.';
COMMENT ON COLUMN public.area.location_id IS 'Foreign key linking the area to its parent location.';
COMMENT ON COLUMN public.area.name IS 'Name of the area.';
COMMENT ON COLUMN public.area.description IS 'Additional details or description of the area.';

CREATE TABLE public.ds_instance (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing unique identifier
    name VARCHAR NOT NULL,                               -- Name of the DeepStream instance
    mq_topic VARCHAR                                -- Message queue topic associated with the DeepStream instance
);

COMMENT ON TABLE public.ds_instance IS 'Represents DeepStream instances used for video analytics.';
COMMENT ON COLUMN public.ds_instance.id IS 'Unique identifier for the DeepStream instance.';
COMMENT ON COLUMN public.ds_instance.name IS 'Name of the DeepStream instance.';
COMMENT ON COLUMN public.ds_instance.mq_topic IS 'Message queue topic associated with the DeepStream instance.';


CREATE TABLE public.camera (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing unique identifier
    name VARCHAR NOT NULL,                               -- Name of the camera
    ds_source_id INTEGER,                                -- Source ID of the camera in the associated DeepStream instance
    ds_instance_id INTEGER,                              -- Foreign key linking to the associated DeepStream instance
    stream_url VARCHAR(2048),                            -- URL for the camera stream
    area_id INTEGER,                                     -- Foreign key linking to the associated area
    CONSTRAINT fk_area FOREIGN KEY (area_id) REFERENCES public.area (id) ON DELETE RESTRICT,
    CONSTRAINT fk_ds_instance FOREIGN KEY (ds_instance_id) REFERENCES public.ds_instance (id) ON DELETE SET NULL
);

COMMENT ON TABLE public.camera IS 'Represents CCTV cameras, including their configurations and stream details.';
COMMENT ON COLUMN public.camera.id IS 'Unique identifier for the camera.';
COMMENT ON COLUMN public.camera.name IS 'Name of the camera.';
COMMENT ON COLUMN public.camera.ds_source_id IS 'Source ID of the camera in the associated DeepStream instance.';
COMMENT ON COLUMN public.camera.ds_instance_id IS 'Foreign key linking the camera to its associated DeepStream instance.';
COMMENT ON COLUMN public.camera.stream_url IS 'URL for the camera stream.';
COMMENT ON COLUMN public.camera.area_id IS 'Foreign key linking the camera to an area.';

CREATE TABLE public.occupancy_data (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing unique identifier
    camera_id INTEGER NOT NULL,                          -- Foreign key linking to the associated camera
    timestamp TIMESTAMP NOT NULL,                        -- Timestamp of the data entry
    entry INTEGER NOT NULL,                              -- Number of entries recorded
    exit INTEGER NOT NULL,                               -- Number of exits recorded
    occupancy INTEGER NOT NULL,                          -- Current occupancy count
    CONSTRAINT fk_camera FOREIGN KEY (camera_id) REFERENCES public.camera (id) ON DELETE CASCADE
);

COMMENT ON TABLE public.occupancy_data IS 'Stores occupancy data for each camera, including entries, exits, and current occupancy at specific timestamps.';
COMMENT ON COLUMN public.occupancy_data.id IS 'Unique identifier for the occupancy data record.';
COMMENT ON COLUMN public.occupancy_data.camera_id IS 'Foreign key linking the occupancy data to the associated camera.';
COMMENT ON COLUMN public.occupancy_data.timestamp IS 'Timestamp when the occupancy data was recorded.';
COMMENT ON COLUMN public.occupancy_data.entry IS 'Number of entries recorded at the specified timestamp.';
COMMENT ON COLUMN public.occupancy_data.exit IS 'Number of exits recorded at the specified timestamp.';
COMMENT ON COLUMN public.occupancy_data.occupancy IS 'Current occupancy count at the specified timestamp.';

INSERT INTO public.location (name, description, address)
VALUES ('Location 1', 'Description of the location', 'Address of the location'); --location details
INSERT INTO public.area (location_id, name, description)
VALUES (1, 'Area 1', 'Description of the area');                         --Area details 
INSERT INTO public.ds_instance (name, mq_topic)
VALUES ('ds-instance-1','json-encoded-events');                                          --deepstream instance 
INSERT INTO public.camera (name, ds_source_id, ds_instance_id, stream_url)
VALUES ('Camera 0', 0, 1, '<rtsp_url>'); 
INSERT INTO public.camera (name, ds_source_id, ds_instance_id, stream_url)
VALUES ('Camera 1', 1, 1, '<rtsp_url>');  
INSERT INTO public.camera (name, ds_source_id, ds_instance_id, stream_url)
VALUES ('Camera 2', 2, 1, '<rtsp_url>');  
INSERT INTO public.camera (name, ds_source_id, ds_instance_id, stream_url)
VALUES ('Camera 3', 3, 1, '<rtsp_url>');                                    --camera details
