// import { expect } from 'chai';
// import { createInstances } from "../instance";
// import { getSigners, initSigners } from "../signers";
// import { asyncDecrypt, awaitAllDecryptionResults } from "../asyncDecrypt";
// import { deployEncryptedCounterFixture } from './EncryptedCounter.fixture';
// // import {Reencrypt , reencrypt} from "../fhevmjsMocked";

// describe('EncryptedCounter', function () {
//   // let encryptedCounter: EncryptedCounter;
//   before(async function () {
//     await initSigners();
//     this.signers = await getSigners();
//     this.relayerAddress = "0x97F272ccfef4026A1F3f0e0E879d514627B84E69";
//   });


//   beforeEach(async function () {
//     const encryptedCounter = await deployEncryptedCounterFixture();
//     this.contractAddress = await encryptedCounter.getAddress();
//     this.contract = encryptedCounter;
//     this.instances = await createInstances(this.signers);
//   });


// // it('should set the counter to 20', async function () {
// //     const transaction = await this.contract.setCounter(20);
// //     await transaction.wait();

// //     const tx2 = await this.contract.connect(this.signers.alice).decryptCounter({ gasLimit: 5_000_000 });
// //       await tx2.wait();
// //       await awaitAllDecryptionResults();
// //       const y = await this.contract._counter();
// //       expect(y).to.equal(20); // 10 

// //   });

//   it('should decrypt the counter to 50 ', async function () {
//     const transaction = await this.contract.increment(50);
//     await transaction.wait();

//     const tx2 = await this.contract.connect(this.signers.alice).decryptCounter({ gasLimit: 5_000_000 });
//       await tx2.wait();
//       await awaitAllDecryptionResults();
//       const y = await this.contract._counter();
//       expect(y).to.equal(60); // 10 

//   });

// });