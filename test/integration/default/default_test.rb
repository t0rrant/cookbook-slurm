# # encoding: utf-8

# Inspec test for recipe slurm::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
if os.debian?
  %w(python-dev python-mysqldb python-mysql.connector).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
