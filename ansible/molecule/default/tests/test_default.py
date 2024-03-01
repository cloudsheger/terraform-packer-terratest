# tests/test_default.py

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_git_is_installed(Package):
    p = Package('git')

    assert p.is_installed

def test_docker_is_started_and_enabled(Service):
    s = Service('docker')

    assert s.is_running
    assert s.is_enabled  