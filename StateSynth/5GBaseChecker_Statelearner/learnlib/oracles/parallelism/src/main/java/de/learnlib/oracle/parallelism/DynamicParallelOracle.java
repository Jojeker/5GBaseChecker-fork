/* Copyright (C) 2013-2022 TU Dortmund
 * This file is part of LearnLib, http://www.learnlib.de/.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package de.learnlib.oracle.parallelism;

import java.util.Collection;
import java.util.concurrent.ExecutorService;
import java.util.function.Supplier;

import de.learnlib.api.oracle.MembershipOracle;
import de.learnlib.api.oracle.parallelism.ParallelOracle;
import de.learnlib.api.query.Query;
import org.checkerframework.checker.index.qual.NonNegative;

/**
 * A specialized {@link AbstractDynamicBatchProcessor} for {@link MembershipOracle}s that implements {@link
 * ParallelOracle}.
 *
 * @param <I>
 *         input symbol type
 * @param <D>
 *         output domain type
 */
public class DynamicParallelOracle<I, D> extends AbstractDynamicBatchProcessor<Query<I, D>, MembershipOracle<I, D>>
        implements ParallelOracle<I, D> {

    public DynamicParallelOracle(Supplier<? extends MembershipOracle<I, D>> oracleSupplier,
                                 @NonNegative int batchSize,
                                 ExecutorService executor) {
        super(oracleSupplier, batchSize, executor);
    }

    @Override
    public void processQueries(Collection<? extends Query<I, D>> queries) {
        processBatch(queries);
    }
}
