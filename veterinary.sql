CREATE SCHEMA IF NOT EXISTS bogdan_didukh DEFAULT CHARACTER SET utf8 ;
USE bogdan_didukh;

create table clinic
(
    id            int auto_increment
        primary key,
    name          varchar(45)  not null,
    street        varchar(45)  not null,
    city          varchar(45)  not null,
    state         varchar(45)  not null,
    zip_code      char(5)      not null,
    phone_number  varchar(15)  not null,
    email_address varchar(320) not null
);

create table illness
(
    id                    int auto_increment
        primary key,
    name                  varchar(45) not null,
    treatment_description text        null
);

create table medical_card
(
    id            int auto_increment
        primary key,
    serial_number varchar(45) not null,
    constraint serial_number_UNIQUE
        unique (serial_number)
);

create table medical_card_has_illness
(
    medical_card_id int not null,
    illness_id      int not null,
    primary key (medical_card_id, illness_id),
    constraint fk_medical_card_has_illness_illness1
        foreign key (illness_id) references illness (id),
    constraint fk_medical_card_has_illness_medical_card1
        foreign key (medical_card_id) references medical_card (id)
);

create table pet_owner
(
    id            int auto_increment
        primary key,
    first_name    varchar(45)  not null,
    last_name     varchar(45)  not null,
    street        varchar(45)  not null,
    city          varchar(45)  not null,
    state         varchar(45)  not null,
    phone_number  varchar(15)  not null,
    email_address varchar(320) not null
);

create table pet_type
(
    id   int auto_increment
        primary key,
    name varchar(45) not null
);

create table pet
(
    id              int auto_increment,
    name            varchar(45) not null,
    pet_owner_id    int         not null,
    pet_type_id     int         not null,
    medical_card_id int         null,
    primary key (id, pet_owner_id, pet_type_id),
    constraint medical_card_id_UNIQUE
        unique (medical_card_id),
    constraint fk_pet_medical_card1
        foreign key (medical_card_id) references medical_card (id),
    constraint fk_pet_pet_owner
        foreign key (pet_owner_id) references pet_owner (id),
    constraint fk_pet_pet_type1
        foreign key (pet_type_id) references pet_type (id)
);

create table staff
(
    id            int auto_increment,
    first_name    varchar(45)  not null,
    last_name     varchar(45)  not null,
    street        varchar(45)  not null,
    city          varchar(45)  not null,
    state         varchar(45)  not null,
    phone_number  varchar(15)  not null,
    email_address varchar(320) not null,
    clinic_id     int          not null,
    primary key (id, clinic_id),
    constraint fk_staff_clinic1
        foreign key (clinic_id) references clinic (id)
);

create table appointment
(
    id              int auto_increment,
    day_of_week     enum ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun') not null,
    end_time        time                                                   not null,
    start_time      time                                                   not null,
    pet_owner_id    int                                                    not null,
    staff_id        int                                                    not null,
    staff_clinic_id int                                                    not null,
    primary key (id, pet_owner_id, staff_id, staff_clinic_id),
    constraint fk_appointment_pet_owner1
        foreign key (pet_owner_id) references pet_owner (id),
    constraint fk_appointment_staff1
        foreign key (staff_id, staff_clinic_id) references staff (id, clinic_id)
);

INSERT INTO bogdan_didukh.clinic (id, name, street, city, state, zip_code, phone_number, email_address) VALUES (1, 'Lkp lev', 'Promyslova', 'Lviv', 'Lvivska', '12345', '1234567890', 'lev@gmail.com');

INSERT INTO bogdan_didukh.staff (id, first_name, last_name, street, city, state, phone_number, email_address, clinic_id) VALUES (1, 'Ivanenko', 'Vasyl', 'Lychakivska', 'Lviv', 'Lvivska', '0987654321', 'i@gmail.com', 1);

INSERT INTO bogdan_didukh.pet_owner (id, first_name, last_name, street, city, state, phone_number, email_address) VALUES (1, 'Marko', 'Polo', 'Bandery', 'Lviv', 'Lvivska', '0896734512', 'mp@gmail.com');

INSERT INTO bogdan_didukh.pet_type (id, name) VALUES (1, 'Cat');
INSERT INTO bogdan_didukh.pet_type (id, name) VALUES (2, 'Dog');

INSERT INTO bogdan_didukh.medical_card (id, serial_number) VALUES (1, '12345');

INSERT INTO bogdan_didukh.illness (id, name, treatment_description) VALUES (1, 'Cancer', 'Operation');

INSERT INTO bogdan_didukh.appointment (id, day_of_week, end_time, start_time, pet_owner_id, staff_id, staff_clinic_id) VALUES (1, 'Mon', '12:00:00', '11:00:00', 1, 1, 1);

INSERT INTO bogdan_didukh.pet (id, name, pet_owner_id, pet_type_id, medical_card_id) VALUES (4, 'Sharik', 1, 2, 1);
INSERT INTO bogdan_didukh.pet (id, name, pet_owner_id, pet_type_id, medical_card_id) VALUES (5, 'Kit', 1, 1, null);

INSERT INTO bogdan_didukh.medical_card_has_illness (medical_card_id, illness_id) VALUES (1, 1);
