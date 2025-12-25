import csv
from datetime import datetime

def read_csv(file_path):
    with open(file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        return list(reader)

def get_row_count(file_path):
    return len(read_csv(file_path))

def validate_total_amount(rows):
    for row in rows:
        quantity = float(row['quantity'])
        unit_price = float(row['unit_price'])
        total_amount = float(row['total_amount'])
        expected = quantity * unit_price
        if total_amount != expected:
            raise AssertionError(
                f"Total mismatch for order {row['order_id']}: {total_amount} != {expected}"
            )

def validate_no_null_customer(rows):
    for row in rows:
        if row.get('customer_id') in (None, '', 'NULL'):
            raise AssertionError("Null customer_id found")

def validate_date_format(rows):
    for row in rows:
        try:
            datetime.strptime(row['order_date'], "%Y-%m-%d")
        except ValueError:
            raise AssertionError(
                f"Invalid date format: {row['order_date']}"
            )

def validate_no_duplicate_orders(rows):
    order_ids = [row['order_id'] for row in rows]
    if len(order_ids) != len(set(order_ids)):
        raise AssertionError("Duplicate order_id found")
