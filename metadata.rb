name 'slurm'

license 'Apache-2.0'

maintainer 'Manuel Torrinha'
maintainer_email 'manuel.torrinha@tecnico.ulisboa.pt'

issues_url 'https://github.com/t0rrant/cookbook-slurm/issues'
source_url 'https://github.com/t0rrant/cookbook-slurm'

description 'Installs/Configures slurm workload manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version '0.4.0'
chef_version '~> 14.0'

supports 'ubuntu', '> 16'
supports 'debian', '> 8'

depends 'mariadb', '~> 2'
depends 'shifter', '~> 0'
# depends 'postfix'
