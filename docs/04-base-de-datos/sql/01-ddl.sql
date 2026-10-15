-- DDL: definición de la estructura (tablas, restricciones e índices).
-- Orden de creación según dependencias de FK: vehicles, customers -> reservations -> rentals.

-- 1) vehicles y customers (Parte 1 - Johann-Tafur) — sin FKs salientes, van primero.

CREATE TABLE vehicles (
    id             BIGSERIAL PRIMARY KEY,
    license_plate  VARCHAR(10) NOT NULL UNIQUE,
    brand          VARCHAR(50) NOT NULL,
    model          VARCHAR(50) NOT NULL,
    year           INT NOT NULL,
    type           VARCHAR(30) NOT NULL,
    status         VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
                   CHECK (status IN ('AVAILABLE', 'RENTED', 'MAINTENANCE', 'RETIRED')),
    price_per_day  NUMERIC(10,2) NOT NULL,
    deactivated_at TIMESTAMP,
    -- Borrado lógico (RN15): un vehículo RETIRED siempre tiene fecha de baja, y uno activo nunca
    CONSTRAINT chk_vehicles_retired CHECK ((status = 'RETIRED') = (deactivated_at IS NOT NULL))
);

CREATE INDEX idx_vehicles_status ON vehicles (status);

CREATE TABLE customers (
    id               BIGSERIAL PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    document_number  VARCHAR(20) NOT NULL UNIQUE,
    email            VARCHAR(100),
    phone            VARCHAR(20),
    active           BOOLEAN NOT NULL DEFAULT TRUE,
    deactivated_at   TIMESTAMP,
    -- Borrado lógico (RN15): un cliente inactivo siempre tiene fecha de baja, y uno activo nunca
    CONSTRAINT chk_customers_active CHECK (active = (deactivated_at IS NULL))
);

CREATE INDEX idx_customers_last_name ON customers (last_name);

-- 2) reservations (Parte 2 - chaarlyez) — depende de vehicles y customers.

CREATE TABLE reservations (
    id            BIGSERIAL PRIMARY KEY,
    vehicle_id    BIGINT NOT NULL REFERENCES vehicles(id),
    customer_id   BIGINT NOT NULL REFERENCES customers(id),
    start_date    DATE NOT NULL,
    end_date      DATE NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                  CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED')),
    CONSTRAINT chk_reservations_dates CHECK (end_date > start_date)
);

CREATE INDEX idx_reservations_vehicle_dates ON reservations (vehicle_id, start_date, end_date);

-- 3) rentals (Parte 3 - mariocardona970546) — depende de vehicles, customers y reservations.

CREATE TABLE rentals (
    id                 BIGSERIAL PRIMARY KEY,
    vehicle_id         BIGINT NOT NULL REFERENCES vehicles(id),
    customer_id        BIGINT NOT NULL REFERENCES customers(id),
    reservation_id     BIGINT UNIQUE REFERENCES reservations(id),
    actual_start_date  TIMESTAMP NOT NULL,
    actual_end_date    TIMESTAMP,
    status             VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                       CHECK (status IN ('ACTIVE', 'FINISHED', 'VOIDED')),
    total_amount       NUMERIC(10,2)
                       CHECK (total_amount IS NULL OR total_amount >= 0),
    CONSTRAINT chk_rentals_dates CHECK (actual_end_date IS NULL OR actual_end_date > actual_start_date),
    -- Un alquiler anulado (RN18) no tiene devolución ni monto
    CONSTRAINT chk_rentals_voided CHECK (status <> 'VOIDED' OR (actual_end_date IS NULL AND total_amount IS NULL))
);

CREATE INDEX idx_rentals_vehicle_status ON rentals (vehicle_id, status);
CREATE INDEX idx_rentals_customer ON rentals (customer_id);
