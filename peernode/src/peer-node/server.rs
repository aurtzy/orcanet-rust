pub mod consumer;
pub mod peer;
pub mod producer;
pub mod store;
mod transfer;

mod routes {
    pub mod bubble_guppies;
    pub mod manta;
    pub mod sea_pig;
}

use axum::Router;
use std::sync::Arc;
use tokio::sync::Mutex;

// shared server state
#[derive(Clone)]
pub struct ServerState {
    pub config: Arc<Mutex<store::Configurations>>,
}

// Main function to setup and run the server
#[tokio::main]
async fn main() {
    let mut config = store::Configurations::new().await;

    // Run market client if it was previously configured
    let _ = config.get_market_client().await;

    let state = ServerState {
        config: Arc::new(Mutex::new(config)),
    };

    let app = Router::new()
        .merge(routes::bubble_guppies::routes())
        .merge(routes::manta::routes())
        .merge(routes::sea_pig::routes())
        .with_state(state);

    // Start the server
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app.into_make_service())
        .await
        .unwrap();
}
