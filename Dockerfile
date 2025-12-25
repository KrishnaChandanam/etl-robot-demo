FROM python:3.11-slim

WORKDIR /work

# Install Python dependencies
COPY requirements.txt /work/requirements.txt
RUN pip install --no-cache-dir -r /work/requirements.txt

# Default command runs the Robot tests; expects repo mounted at /work
CMD ["robot", "--outputdir", "/work/results", "tests/etl_validation.robot"]