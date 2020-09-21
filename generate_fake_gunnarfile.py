#!/usr/bin/env python

import csv
import faker
import itertools
import sys



def header_v1():
    return(
    'first_name',
    'last_name', 
    'work_office_location',
    'remote_location',
    'work_office_phone',
    'work_mobile_phone',
    'personal_mobile_phone'
    )

def make_row_v1(fake):
    fname = fake.first_name()
    lname = fake.last_name()
    wrk_off_loc = "1700 G St NW Washington DC 20001"
    remote_loc = fake.address()
    wrk_ph = fake.phone_number()
    wrk_mob_ph = fake.phone_number()
    pers_mob_ph = fake.phone_number()

    return (fname,lname,wrk_off_loc,remote_loc,wrk_ph,wrk_mob_ph,pers_mob_ph)

def row_factory(faker_instance, row_generator):

    infinite_stream = iter(int,1)

    return ( row_generator(faker_instance) for n  in infinite_stream )


if __name__ == '__main__':

    header = header_v1

    try:
        num_rows = int(sys.argv[1])
    except ( IndexError, ValueError ):
        num_rows = 2
    try:
        file_name = sys.argv[2]
    except IndexError:
        file_name = '-'

    fake = faker.Faker('en_US')
    rows = row_factory(fake,make_row_v1)

    header_stream = iter([header(),])
    first_n_rows = itertools.islice(rows,num_rows)

    data = itertools.chain(header_stream, first_n_rows)

    if file_name == '-':
        out_f = sys.stdout
    else:
        out_f = open(file_name,'w')

    csv_w = csv.writer(out_f)
    csv_w.writerows(data)
    

