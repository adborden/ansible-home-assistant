"""Role testing files using testinfra."""


def test_certbot(host):
    """Assert certbot is installed."""
    certbot = host.package("certbot")

    assert certbot.is_installed


def test_certbot_credentials(host):
    """Assert credentials installed."""
    credentials = host.file('/etc/google-account.json')

    assert credentials.exists
    assert credentials.user == 'root'
    assert credentials.group == 'root'
    assert credentials.mode == 0o600
