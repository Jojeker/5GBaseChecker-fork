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
package de.learnlib.algorithms.oml.ttt.dt;

import java.util.Collection;

import org.checkerframework.checker.nullness.qual.Nullable;

/**
 * @author fhowar
 */
public interface Children<I, D> {

    @Nullable AbstractDTNode<I, D> child(D out);

    D key(AbstractDTNode<I, D> child);

    void addChild(D out, AbstractDTNode<I, D> child);

    void replace(DTLeaf<I, D> oldNode, DTInnerNode<I, D> newNode);

    Collection<AbstractDTNode<I, D>> all();

}
