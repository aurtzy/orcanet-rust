//! DHT client for interacting with the DHT server

use std::net::Ipv4Addr;

use anyhow::Result;
use cid::Cid;
use futures::{
    channel::{mpsc::Sender, oneshot},
    SinkExt,
};
use libp2p::{Multiaddr, PeerId};

use crate::{
    command::{Command, CommandCallback},
    CommandOk, CommandResult,
};

#[derive(Debug)]
pub struct DhtClient {
    sender: Sender<CommandCallback>,
}

impl DhtClient {
    pub(crate) const fn new(sender: Sender<CommandCallback>) -> Self {
        Self { sender }
    }

    pub async fn listen_on(&mut self, addr: impl Into<Multiaddr>) -> Result<CommandOk> {
        let (callback_sender, receiver) = oneshot::channel();
        let addr = addr.into();
        self.sender
            .send((Command::Listen { addr }, callback_sender))
            .await?;
        receiver.await?
    }

    pub async fn bootstrap(
        &mut self,
        boot_nodes: impl IntoIterator<Item = (PeerId, Multiaddr)>,
    ) -> Result<CommandOk> {
        let (callback_sender, receiver) = oneshot::channel();
        self.sender
            .send((
                Command::Bootstrap {
                    boot_nodes: boot_nodes.into_iter().collect(),
                },
                callback_sender,
            ))
            .await?;
        receiver.await?
    }

    pub async fn dial(&mut self, peer_id: PeerId, addr: Multiaddr) -> CommandResult {
        let (callback_sender, receiver) = oneshot::channel();
        self.sender
            .send((Command::Dial { peer_id, addr }, callback_sender))
            .await?;
        receiver.await?
    }

    pub async fn register(
        &mut self,
        file_cid: &[u8],
        ip: impl Into<Ipv4Addr>,
        port: u16,
        price_per_mb: u64,
    ) -> CommandResult {
        let (callback_sender, receiver) = oneshot::channel();
        let file_cid = Cid::try_from(file_cid)?;
        self.sender
            .send((
                Command::Register {
                    file_cid,
                    ip: ip.into(),
                    port,
                    price_per_mb,
                },
                callback_sender,
            ))
            .await?;
        receiver.await?
    }

    pub async fn get_file(&mut self, file_cid: &[u8]) -> CommandResult {
        let (callback_sender, receiver) = oneshot::channel();
        let file_cid = Cid::try_from(file_cid)?;
        self.sender
            .send((Command::GetFile { file_cid }, callback_sender))
            .await?;
        receiver.await?
    }

    pub async fn get_closest_peers(&mut self, file_cid: &[u8]) -> CommandResult {
        let (callback_sender, receiver) = oneshot::channel();
        let file_cid = Cid::try_from(file_cid)?;
        self.sender
            .send((Command::GetClosestPeers { file_cid }, callback_sender))
            .await?;
        receiver.await?
    }
}

#[cfg(test)]
mod tests {
    use futures::{channel::oneshot::Sender, StreamExt};
    use libp2p::{Multiaddr, PeerId};
    use pretty_assertions::assert_eq;

    use crate::{command::Command, CommandOk, CommandResult};

    use super::DhtClient;
    // TODO: write tests

    #[tokio::test]
    #[should_panic]
    async fn test_bootstrap_should_fail() {
        let (sender, mut mock_receiver) =
            futures::channel::mpsc::channel::<(Command, Sender<CommandResult>)>(16);
        let mut client = DhtClient::new(sender);
        let mock_id = libp2p::PeerId::random();
        tokio::spawn(async move {
            while let Some(command) = mock_receiver.next().await {
                if let Command::Bootstrap { boot_nodes } = command.0 {
                    if boot_nodes.is_empty() {
                        command
                            .1
                            .send(Err(anyhow::anyhow!("no boot nodes")))
                            .unwrap();
                    }
                } else {
                    panic!("unexpected command: {:?}", command.0);
                }
            }
        });
        if let CommandOk::Bootstrap {
            peer,
            num_remaining,
        } = client
            .bootstrap([(
                PeerId::random(),
                "/ip4/127.0.0.1".parse::<Multiaddr>().unwrap(),
            )])
            .await
            .unwrap()
        {
            assert_eq!(peer, mock_id);
            assert_eq!(num_remaining, 32);
        }
    }

    #[tokio::test]
    async fn test_bootstrap_basic() {
        let (sender, mut mock_receiver) =
            futures::channel::mpsc::channel::<(Command, Sender<CommandResult>)>(16);
        let mut client = DhtClient::new(sender);
        let mock_id = libp2p::PeerId::random();
        tokio::spawn(async move {
            while let Some(command) = mock_receiver.next().await {
                if let Command::Bootstrap {
                    boot_nodes: _boot_nodes,
                } = command.0
                {
                    command
                        .1
                        .send(Ok(CommandOk::Bootstrap {
                            peer: mock_id,
                            num_remaining: 32,
                        }))
                        .unwrap();
                } else {
                    panic!("unexpected command: {:?}", command.0);
                }
            }
        });
        if let CommandOk::Bootstrap {
            peer,
            num_remaining,
        } = client
            .bootstrap([(
                PeerId::random(),
                "/ip4/127.0.0.1".parse::<Multiaddr>().unwrap(),
            )])
            .await
            .unwrap()
        {
            assert_eq!(peer, mock_id);
            assert_eq!(num_remaining, 32);
        }
    }

    #[tokio::test]
    async fn test_listen_on_basic() {
        let (sender, mut mock_receiver) =
            futures::channel::mpsc::channel::<(Command, Sender<CommandResult>)>(16);
        let expected_addr = "/ip4/127.0.0.1".parse::<Multiaddr>().unwrap();
        tokio::spawn(async move {
            if let Some(command) = mock_receiver.next().await {
                if let Command::Listen { addr: _addr } = command.0 {
                    command
                        .1
                        .send(Ok(CommandOk::Listen {
                            addr: expected_addr,
                        }))
                        .unwrap();
                } else {
                    panic!("unexpected command: {:?}", command.0);
                }
            }
        });
        let mut client = DhtClient::new(sender);
        // NOTE: this thing blocks until the oneshot is received back
        if let CommandOk::Listen { addr } = client
            .listen_on("/ip4/127.0.0.1".parse::<Multiaddr>().unwrap())
            .await
            .unwrap()
        {
            assert_eq!(addr, "/ip4/127.0.0.1".parse::<Multiaddr>().unwrap());
        }
    }

    #[tokio::test]
    #[should_panic]
    async fn test_listen_on_command_bad_multiaddr() {
        let (sender, mut mock_receiver) =
            futures::channel::mpsc::channel::<(Command, Sender<CommandResult>)>(16);
        tokio::spawn(async move {
            while let Some(command) = mock_receiver.next().await {
                if let Command::Listen { addr: _addr } = command.0 {
                    command
                        .1
                        .send(Ok(CommandOk::Listen {
                            addr: "/ip4/".parse::<Multiaddr>().unwrap(),
                        }))
                        .unwrap();
                } else {
                    panic!("unexpected command: {:?}", command.0);
                }
            }
        });
        let mut client = DhtClient::new(sender);
        client
            .listen_on("/ip4/1270.0.1".parse::<Multiaddr>().unwrap())
            .await
            .unwrap();
    }
}
