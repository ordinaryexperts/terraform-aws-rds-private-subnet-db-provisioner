#!/usr/bin/python
import ansible.inventory
import ansible.playbook
import ansible.runner
from ansible import utils
from ansible import callbacks


def run_playbook(**kwargs):
    stats = callbacks.AggregateStats()
    playbook_cb = callbacks.PlaybookCallbacks(verbose=utils.VERBOSITY)
    runner_cb = callbacks.PlaybookRunnerCallbacks(
        stats, verbose=utils.VERBOSITY)

    out = ansible.playbook.PlayBook(
        callbacks=playbook_cb,
        runner_callbacks=runner_cb,
        stats=stats,
        **kwargs
    ).run()

    return out


def handler(event, context):
    return main()


def main():
    out = run_playbook(
        playbook='test.yml',
        inventory=ansible.inventory.Inventory(['localhost'])

    )
    return (out)


if __name__ == '__main__':
    main()
