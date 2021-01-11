"""Role testing files using testinfra."""


def test_docker(host):
    """Assert docker is installed"""
    docker = host.package("docker.io")

    assert docker.is_installed


def test_home_assistant_service(host):
    """Assert home-assistant service is installed."""
    ha = host.file('/etc/systemd/system/home-assistant.service')

    assert ha.exists
    assert ha.owner == 'root'
    assert ha.group == 'root'
    assert ha.mode == 0o644


def test_home_assistant_enabled(host):
    """Assert home-assistant service is enabled."""
    ha = host.service('home-assistant')

    assert ha.is_running
    assert ha.is_enabled


def test_docker_cron(host):
    """Assert docker maintenance crontab is installed."""
    cron = host.file('/etc/cron.d/docker')

    assert cron.exists
    assert cron.owner == 'root'
    assert cron.group == 'root'
    assert cron.mode == 0o644
