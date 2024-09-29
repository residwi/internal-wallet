# Internal Wallet

## Installation

1. **Build the Docker image**

    You can build the image using the following command:

    ```bash
    docker build -t internal-wallet .
    ```

    This will create a Docker image named `internal-wallet`.

2. **Run the Docker container**

    You can run the container using the following command:

    ```bash
    docker run -p 3000:3000 internal-wallet
    ```

    This will start the Rails server on port 3000.

3. **Setup the database**

    In another terminal window, run the following command:

    ```bash
    docker exec -it <container_id> bin/rails db:setup
    ```

    Replace `<container_id>` with the ID of your Docker container. This will create the database, load the schema and initialize it with the seed data.

4. **Visit the application**

    Open your web browser and visit `http://localhost:3000`.

## Setup RapidAPI Key

Set the `RAPID_API_KEY` environment variable to your RapidAPI key.
