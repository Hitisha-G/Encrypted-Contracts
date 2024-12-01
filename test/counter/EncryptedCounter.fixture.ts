import { ethers } from 'hardhat';
import type { EncryptedCounter } from '../../types';
import { getSigners } from '../signers';

export async function deployEncryptedCounterFixture(): Promise<EncryptedCounter> {
  const signers = await getSigners();

  const contractFactory = await ethers.getContractFactory('EncryptedCounter');
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment(); // Ensure deployment is complete

  return contract as EncryptedCounter;
}