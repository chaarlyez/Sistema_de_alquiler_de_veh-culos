-- DML: datos de ejemplo (semilla) para demos, pruebas y capturas de pantalla.
-- Requiere haber ejecutado antes 01-ddl.sql. Precios en ARS, basados en el anexo de
-- docs/02-requerimientos.md (sección 8). Los ids se asignan por BIGSERIAL (1, 2, 3...).

INSERT INTO vehicles (license_plate, brand, model, year, type, status, price_per_day, deactivated_at) VALUES
    ('AB123CD', 'Fiat',   'Cronos', 2023, 'Económico', 'AVAILABLE',   80000.00, NULL),
    ('AC456EF', 'Toyota', 'Yaris',  2022, 'Económico', 'RENTED',      85000.00, NULL),
    ('AD789GH', 'Toyota', 'Hilux',  2024, 'Pick-up',   'AVAILABLE',  200000.00, NULL),
    ('AE012IJ', 'Ford',   'Ranger', 2021, 'Pick-up',   'MAINTENANCE',195000.00, NULL),
    ('AF345KL', 'Fiat',   'Argo',   2019, 'Económico', 'RETIRED',     70000.00, '2026-03-10 09:00:00');

INSERT INTO customers (first_name, last_name, document_number, email, phone, active, deactivated_at) VALUES
    ('Lucía',  'Fernández', '30111222', 'lucia.fernandez@example.com', '1155550101', TRUE,  NULL),
    ('Martín', 'Gómez',     '28333444', 'martin.gomez@example.com',    '1155550102', TRUE,  NULL),
    ('Sofía',  'Pereyra',   '35555666', NULL,                          '1155550103', TRUE,  NULL),
    ('Diego',  'Ramírez',   '27777888', 'diego.ramirez@example.com',   NULL,         FALSE, '2026-02-01 10:30:00');

INSERT INTO reservations (vehicle_id, customer_id, start_date, end_date, status) VALUES
    (2, 1, '2026-04-01', '2026-04-05', 'CONFIRMED'),  -- origina el alquiler 1
    (3, 2, '2026-05-10', '2026-05-15', 'PENDING'),
    (1, 3, '2026-05-01', '2026-05-03', 'CANCELLED');

INSERT INTO rentals (vehicle_id, customer_id, reservation_id, actual_start_date, actual_end_date, status, total_amount) VALUES
    (2, 1, 1,    '2026-04-01 10:00:00', NULL,                  'ACTIVE',   NULL),         -- desde reserva, en curso
    (1, 2, NULL, '2026-03-01 09:00:00', '2026-03-04 09:30:00', 'FINISHED', 240000.00),    -- directo, 3 días
    (3, 3, NULL, '2026-03-20 15:00:00', NULL,                  'VOIDED',   NULL);         -- anulado (RN18)
